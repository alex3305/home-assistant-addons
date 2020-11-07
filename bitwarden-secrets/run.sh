#!/usr/bin/env bashio

SECRETS_FILE=/config/secrets.yaml

BW_SERVER=$(bashio::config 'bitwarden.server')
BW_USERNAME=$(bashio::config 'bitwarden.username')
BW_PASSWORD=$(bashio::config 'bitwarden.password')
BW_ORGANIZATION=$(bashio::config 'bitwarden.organization')

REPEAT_ACTIVE=$(bashio::config 'repeat.enabled')
REPEAT_INTERVAL=$(bashio::config 'repeat.interval')

function generate_secrets {
    rm -f ${SECRETS_FILE}
    touch ${SECRETS_FILE}
    printf "# Home Assistant secrets file, managed by Bitwarden.\n\n" >> ${SECRETS_FILE}

    for row in $(bw list items --organizationid ${BW_ORG_ID} | jq -c '.[] | select(.type == 1) | [.login.username, .login.password]')
    do
        key=$(echo $row | jq -r '.[0]')
        value=$(echo $row | jq -r '.[1]')
        echo "${key}: ${value}" >> ${SECRETS_FILE}
    done

    chmod go-r ${SECRETS_FILE}
}

bashio::log.info "Configuring Bitwarden server..."
bw config server ${BW_SERVER}

bashio::log.info "Logging into Bitwarden..."
export BW_SESSION=$(bw login --raw ${BW_USERNAME} ${BW_PASSWORD})

bashio::log.info "Login succesful! Retrieving organization id..."
export BW_ORG_ID=$(bw get organization "${BW_ORGANIZATION}" | jq -r '.id')

while true; do
    # TODO check if login is still valid...
    
    bashio::log.info "Generating secrets file..."
    generate_secrets
    bashio::log.info "Home Assistant secrets created."
    
    # TODO generate_secret_files...

    if [ ! "$REPEAT_ACTIVE" == "true" ]; then
        exit 0
    fi
    sleep "$REPEAT_INTERVAL"
done
