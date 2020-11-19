#!/usr/bin/env bashio

#
# Global variables
#

BW_SERVER=$(bashio::config 'bitwarden.server')
BW_USERNAME=$(bashio::config 'bitwarden.username')
BW_PASSWORD=$(bashio::config 'bitwarden.password')
BW_ORGANIZATION=$(bashio::config 'bitwarden.organization')

if bashio::config.true 'repeat.enabled'; then
    REPEAT_ENABLED="true"
    REPEAT_INTERVAL=$(bashio::config 'repeat.interval')
    bashio::log.debug "Repeat enabled with interval ${REPEAT_INTERVAL}."
else
    REPEAT_ENABLED="false"
fi

if bashio::config.exists 'secrets_file'; then
    SECRETS_FILE="/config/$(bashio::config 'secrets_file')"
    bashio::log.debug "Custom secrets file set to ${SECRETS_FILE}."
else
    SECRETS_FILE="/config/secrets.yaml"
fi

if bashio::config.exists 'use_username_as_key' && bashio::config.true 'use_username_as_key'; then
    USE_USERNAME_AS_KEY="true"
    bashio::log.debug "Option use_username_as_key enabled."
else
    USE_USERNAME_AS_KEY="false"
fi

USE_USERNAME_AS_KEY=$(bashio::config 'use_username_as_key')

#
# Script functions
#

function login {
    bashio::log.debug "Configuring Bitwarden server..."
    bw config server ${BW_SERVER}

    bashio::log.debug "Logging into Bitwarden..."
    export BW_SESSION=$(bw login --raw ${BW_USERNAME} ${BW_PASSWORD})

    if [ $? -eq 0 ]; then
        bashio::log.info "Bitwarden login succesful!"
        bashio::log.debug "Retrieving organization id..."
    else
        bashio::log.fatal "Bitwarden login failed. Exiting..."
        exit 1
    fi
}

function logout {
    # Unset the previously set environment variables
    unset BW_SESSION
    unset BW_ORG_ID

    # Logout and ignore possible errors
    bw logout &>/dev/null
    bashio::log.info "Logged out of Bitwarden."
}

function login_check {
    bw login --check &>/dev/null

    if [ $? -eq 0 ]; then
        bashio::log.debug "Logged in to Bitwarden"
    else
        bashio::log.warn "Bitwarden login expired. Logging in again..."
        login
    fi
}

function set_org_id {
    export BW_ORG_ID=$(bw get organization "${BW_ORGANIZATION}" | jq -r '.id') 2>/dev/null

    if [ $? -eq 0 ]; then
        bashio::log.debug "Retrieved organization id for ${BW_ORGANIZATION}"
    else
        bashio::log.fatal "Could not retrieve Bitwarden organization ${BW_ORGANIZATION}. Exiting..."
        exit 1
    fi
}

function generate_secrets {
    rm -f ${SECRETS_FILE}
    touch ${SECRETS_FILE}
    printf "# Home Assistant secrets file\n" >> ${SECRETS_FILE}
    printf "# DO NOT MODIFY -- Managed by Bitwarden Secrets for Home Assistant add-on\n\n" >> ${SECRETS_FILE}

    for row in $(bw list items --organizationid ${BW_ORG_ID} | jq -c '.[] | select(.type == 1) | (.|@base64)'); do
        row_contents=$(echo ${row} | jq -r '@base64d')

        # This is the old style of parsing and writing secrets (DEPRECATED).
        if bashio::var.true ${USE_USERNAME_AS_KEY}; then
            username=$(echo $row_contents | jq -r '.login.username')
            password=$(echo $row_contents | jq -r '.login.password')

            if [ "${username}" != "null" ] && [ "${password}" != "null" ]; then
                bashio::log.debug "Writing ${username} with ${password}"
                echo "${username}: ${password}" >> ${SECRETS_FILE}
            fi
            
            continue
        fi

        name=$(echo $row_contents | jq -r '.name' | tr '?:&,%@-' ' ' | tr '[]{}#*!|> ' '_' | tr -s '_' | tr '[:upper:]' '[:lower:]')
        
        write_field "${name}" "${row_contents}" ".login.username" "username"
        write_field "${name}" "${row_contents}" ".login.password" "password"
        write_field "${name}" "${row_contents}" ".notes" "notes"

        write_uris "${name}" "${row_contents}"
        write_custom_fields "${name}" "${row_contents}"

        bashio::log.trace "ROW: ${row_contents}"
    done

    chmod go-wrx ${SECRETS_FILE}
}

function generate_secret_files {
    for row in $(bw list items --organizationid ${BW_ORG_ID} | jq -c '.[] | select(.type == 2) | [.name, (.notes|@base64)]')
    do
        file=$(echo $row | jq -r '.[0]')
        dirname=$(dirname $file)
        basename=$(basename $file)
        
        mkdir -p /config/${dirname}
        rm -f /config/${dirname}/${basename}
        
        echo ${row} | jq -r '.[1] | @base64d' > "/config/${dirname}/${basename}"
        chmod go-wrx "/config/${dirname}/${basename}"
    done
}

function write_field {
    secret_name=${1}
    row_contents=${2}
    field_name=${3}
    suffix=${4}

    bashio::log.trace "Parsing row ${row_contents}"
    field="$(echo ${row_contents} | jq -r ${field_name})"
    
    if [ "${field}" != "null" ]; then
        bashio::log.debug "Writing ${secret_name}_${suffix} with ${field}"
        echo "${secret_name}_${suffix}: '${field}'" >> ${SECRETS_FILE}
    fi
}

function write_uris {
    secret_name=${1}
    row_contents=${2}

    if [ "$(echo ${row_contents} | jq -r '.login.uris | length')" -gt "0" ]; then
        i=1
        
        for uris in $(echo ${row_contents} | jq -c '.login.uris | .[] | @base64' ); do
            uri=$(echo ${uris} | jq -r '@base64d' |  jq -r '.uri')

            if [ "${uri}" != "null" ]; then
                bashio::log.debug "Writing ${secret_name}_uri_${i} with ${uri}"
                echo "${secret_name}_uri_${i}: '${uri}'" >> ${SECRETS_FILE}
                
                ((i=i+1))
            fi
        done
    fi
}

function write_custom_fields {
    secret_name=${1}
    row_contents=${2}

    if [ "$(echo ${row_contents} | jq -r '.fields | length')" -gt "0" ]; then
        for fields in $(echo ${row_contents} | jq -c '.fields | .[] | @base64'); do
            field_contents=$(echo ${fields} | jq -r '@base64d')
            field_name=$(echo ${field_contents} | jq -r '.name' | tr '?:&,%@-' ' ' | tr '[]{}#*!|> ' '_' | tr -s '_' | tr '[:upper:]' '[:lower:]')
            field_value=$(echo ${field_contents} | jq -r '.value')

            if [ "${field_name}" != "null" ] && [ "${field_value}" != "null" ]; then
                bashio::log.debug "Writing ${secret_name}_${field_name} with ${field_value}"
                echo "${secret_name}_${field_name}: '${field_value}'" >> ${SECRETS_FILE}
            fi
        done
    fi
}

#
# Start of main loop
#

bashio::log.info "Start retrieving your Home Assistant secrets from Bitwarden"
login
set_org_id

while true; do
    bashio::log.debug "Generating secrets file from logins..."
    generate_secrets
    bashio::log.info "Home Assistant secrets created."
    
    bashio::log.debug "Generating secret files from notes..."
    generate_secret_files
    bashio::log.info "Secret files created."

    if [ "${REPEAT_ENABLED}" != "true" ]; then
        logout
        exit 0
    fi

    sleep "${REPEAT_INTERVAL}"
    login_check

    bashio::log.debug "Syncing Bitwarden vault..."
    bw sync &>/dev/null
    bashio::log.info "Bitwarden vault synced at: $(bw sync --last)"
done
