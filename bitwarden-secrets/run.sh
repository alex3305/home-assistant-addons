#!/usr/bin/env bashio

#
# Global variables
#

SECRETS_FILE=/config/secrets.yaml

BW_SERVER=$(bashio::config 'bitwarden.server')
BW_USERNAME=$(bashio::config 'bitwarden.username')
BW_PASSWORD=$(bashio::config 'bitwarden.password')
BW_ORGANIZATION=$(bashio::config 'bitwarden.organization')

REPEAT_ENABLED=$(bashio::config 'repeat.enabled')
REPEAT_INTERVAL=$(bashio::config 'repeat.interval')

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
    printf "# Home Assistant secrets file, managed by Bitwarden.\n\n" >> ${SECRETS_FILE}

    for row in $(bw list items --organizationid ${BW_ORG_ID} | jq -c '.[] | select(.type == 1) | [(.login.username|@base64), (.login.password|@base64)]')
    do
        key=$(echo $row | jq -r '.[0] | @base64d')
        value=$(echo $row | jq -r '.[1] | @base64d')
        echo "${key}: ${value}" >> ${SECRETS_FILE}
    done

    chmod go-wrx ${SECRETS_FILE}
}

function generate_secret_files {
    for row in $(bw list items --organizationid ${BW_ORG_ID} | jq -c '.[] | select(.type == 2) | [.name, (.notes|@base64)]')
    do
        file=$(echo $row | jq -r '.[0]')
        dirname=$(dirname $file)
        basename=$(basename $file)
        
        contents=$(echo $row | jq -r '.[1] | @base64d')
        
        mkdir -p /config/${dirname}
        rm -f /config/${dirname}/${basename}
        
        echo ${contents} > "/config/${dirname}/${basename}"
        chmod go-wrx "/config/${dirname}/${basename}"
    done
}

#
# Start of main loop
#

bashio::log.info "Start retrieving your Home Assistant secrets from Bitwarden"
login
set_org_id

while true; do
    login_check
    
    bashio::log.info "Generating secrets file from logins..."
    generate_secrets
    bashio::log.info "Home Assistant secrets created."
    
    bashio::log.info "Generating secret files from notes..."
    generate_secret_files
    bashio::log.info "Secret files created."

    if [ ! "${REPEAT_ENABLED}" == "true" ]; then
        logout
        exit 0
    fi

    sleep "${REPEAT_INTERVAL}"
done
