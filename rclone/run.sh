#!/usr/bin/env bash
set -e
CONFIG_PATH=/data/options.json

RCLONE_CONFIG=$(/usr/bin/jq --raw-output '.configuration_path' $CONFIG_PATH)

REMOTE=$(/usr/bin/jq --raw-output '.remote' $CONFIG_PATH)
REMOTE_PATH=$(/usr/bin/jq --raw-output '.remote_path' $CONFIG_PATH)

LOCAL_RETENTION=$(/usr/bin/jq --raw-output '.local_retention_days' $CONFIG_PATH)
REMOTE_RETENTION=$(/usr/bin/jq --raw-output '.remote_retention_days' $CONFIG_PATH)

echo "[ADDON] Pruning local files..."
/usr/bin/find /backup/ -mtime +${LOCAL_RETENTION} -type f -delete

echo "[ADDON] Starting copy..."
/usr/bin/rclone -v --config ${RCLONE_CONFIG} --max-age "${REMOTE_RETENTION}d" copy /backup/ "${REMOTE}:${REMOTE_PATH}"
echo "[ADDON] Copy finished"
