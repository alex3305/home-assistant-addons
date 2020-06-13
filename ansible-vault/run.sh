#!/usr/bin/env bashio

PASSWORD_FILE=/tmp/password
ENCRYPTED_FILE=$(bashio::config 'encrypted_file')
OUTPUT_FILE=$(bashio::config 'output_file')

if [[ $(bashio::config.exists 'password') -eq 0 ]]; then
    bashio::log.debug "Password found"
    echo "$(bashio::config 'password')" > "${PASSWORD_FILE}"
elif [[ $(bashio::config.exists 'password_file') -eq 0 ]]; then
    bashio::log.debug "Password file found"
    cp $(bashio::config 'password_file') "${PASSWORD_FILE}"
else
    bashio::log.error "No password or password file found."
    bashio::log.error "Please define a password or password file and re-run this add-on."
    exit;
fi

bashio::log.info "Decrypting ${ENCRYPTED_FILE}"
ansible-vault decrypt --vault-password-file "${PASSWORD_FILE}" \
                      --output "${OUTPUT_FILE}" \
                      "${ENCRYPTED_FILE}"
bashio::log.info "Successfully decrypted to ${OUTPUT_FILE}"

rm -f "${PASSWORD_FILE}"
