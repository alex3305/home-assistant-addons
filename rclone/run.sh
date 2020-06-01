#!/usr/bin/env bashio

RCLONE_CONFIG=$(bashio::config 'configuration_path')
REMOTES=$(bashio::config 'remotes')
LOCAL_RETENTION=$(bashio::config 'local_retention_days')

bashio::log.info "Pruning local files..."
find /backup/ -mtime +${LOCAL_RETENTION} -type f -delete
bashio::log.info "Pruning local files finished"

for remote in ${REMOTES}; do
    remote_name=$(bashio::jq "${remote}" ".name")
    remote_path=$(bashio::jq "${remote}" ".path")
    remote_retention=$(bashio::jq "${remote}" ".retention_days")

    bashio::log.info "Starting remote copy for ${remote_name}..."
    
    rclone --config ${RCLONE_CONFIG} \
        sync -v \
        --max-age "${remote_retention}d" \
        --delete-during \
        --delete-excluded \
        --ignore-errors \
        --ignore-existing /backup/ "${remote_name}:${remote_path}"
    
    bashio::log.info "Remote copy for ${remote_name} finished"
done
