#!/usr/bin/env bashio

RCLONE_CONFIG=$(bashio::config 'configuration_path')

REMOTE=$(bashio::config 'remote')
REMOTE_PATH=$(bashio::config 'remote_path')

LOCAL_RETENTION=$(bashio::config 'local_retention_days')
REMOTE_RETENTION=$(bashio::config 'remote_retention_days')

bashio::log.info "Pruning local files..."
find /backup/ -mtime +${LOCAL_RETENTION} -type f -delete
bashio::log.info "Pruning local files finished"

bashio::log.info "Starting remote copy..."
rclone -v --config ${RCLONE_CONFIG} \
    --max-age "${REMOTE_RETENTION}d" \
    --ignore-existing copy /backup/ "${REMOTE}:${REMOTE_PATH}"
bashio::log.info "Remote copy finished"
