#!/bin/sh

echo "[ADDON] Generating static config..."
j2 /etc/traefik/traefik.yaml.j2 /data/options.json -o /etc/traefik/traefik.yaml
echo "[ADDON] Static config set in /etc/traefik/traefik.yaml"

echo "[ADDON] Extracting environment variables..."
ENV_VARS=$(j2 /etc/traefik/env.j2 /data/options.json)

if [ -z "$ENV_VARS" ]; then
    echo "[ADDON] No additional environment variables found"
else
    echo "[ADDON] Extracted ${ENV_VARS}"
fi

echo "[ADDON] Starting Traefik..."
if [ -z "$ENV_VARS" ]; then
    /usr/local/bin/traefik
else
    export "${ENV_VARS}"
    exec /usr/local/bin/traefik
fi
