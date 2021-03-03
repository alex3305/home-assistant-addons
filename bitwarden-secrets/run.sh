#!/usr/bin/env bashio

#
# Global variables
#

TEMP_SECRETS_FILE="/tmp/secrets.yaml"

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

#
# Script functions
#

function login {
    bashio::log.debug "Configuring Bitwarden server..."
    bw config server ${BW_SERVER} &>/dev/null

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
        bashio::log.warning "Bitwarden login expired. Logging in again..."
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
    touch ${TEMP_SECRETS_FILE}
    
    printf "# Home Assistant secrets file\n" >> ${TEMP_SECRETS_FILE}
    printf "# DO NOT MODIFY -- Managed by Bitwarden Secrets for Home Assistant add-on\n\n" >> ${TEMP_SECRETS_FILE}

    for row in $(bw list items --organizationid ${BW_ORG_ID} | jq -c '.[] | select(.type == 1) | (.|@base64)'); do
        row_contents=$(echo ${row} | jq -r '@base64d')
        name=$(echo $row_contents | jq -r '.name' | tr '?:&,%@-' ' ' | tr '[]{}#*!|> ' '_' | tr -s '_' | tr '[:upper:]' '[:lower:]')
        
        write_field "${name}" "${row_contents}" ".login.username" "username"
        write_field "${name}" "${row_contents}" ".login.password" "password"
        write_field "${name}" "${row_contents}" ".notes" "notes"

        write_uris "${name}" "${row_contents}"
        write_custom_fields "${name}" "${row_contents}"

        bashio::log.trace "ROW: ${row_contents}"
    done
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
        echo "${secret_name}_${suffix}: '${field}'" >> ${TEMP_SECRETS_FILE}
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
                echo "${secret_name}_uri_${i}: '${uri}'" >> ${TEMP_SECRETS_FILE}
                
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
                echo "${secret_name}_${field_name}: '${field_value}'" >> ${TEMP_SECRETS_FILE}
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
    num_of_items=$(bw list items --organizationid ${BW_ORG_ID} | jq length)

    if [ ${num_of_items} -gt 0 ]; then
        bashio::log.debug "Generating secrets.yaml file from login entries..."
        generate_secrets
        bashio::log.debug "Home Assistant secrets generated."

        bashio::log.debug "Comparing newly generated secrets to secrets.yaml..."
        if cmp -s -- "${TEMP_SECRETS_FILE}" "${SECRETS_FILE}"; then
            rm -f ${TEMP_SECRETS_FILE}
            bashio::log.debug "No secrets changes detected."
        else
            bashio::log.info "Changed from Bitwarden detected, replacing secrets.yaml..."
            mv -f ${TEMP_SECRETS_FILE} ${SECRETS_FILE}
            chmod go-wrx ${SECRETS_FILE}
        fi
        
        bashio::log.debug "Generating secret files from notes..."
        generate_secret_files
        bashio::log.info "Secret files created."
    else
        bashio::log.error "No secrets found in your organisation!"
        bashio::log.error "--------------------------------------"
        bashio::log.error "Ensure that you have:"
        bashio::log.error "  - At least 1 secret in your organisation ${BW_ORGANIZATION}"
        bashio::log.error "  - Bitwarden is started when using the Bitwarden add-on"
        bashio::log.error "--------------------------------------"
    fi

    if [ "${REPEAT_ENABLED}" != "true" ]; then
        break
    fi

    sleep "${REPEAT_INTERVAL}"
    login_check

    bashio::log.debug "Syncing Bitwarden vault..."
    bw sync &>/dev/null
    bashio::log.info "Bitwarden vault synced at: $(bw sync --last)"
done

logout
exit 0
