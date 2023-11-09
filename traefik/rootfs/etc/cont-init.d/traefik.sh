#!/usr/bin/with-contenv bashio

bashio::log.info "Ensuring SSL directory..."
mkdir -p /ssl/traefik/

bashio::log.info "Generating static config..."
gomplate -f /etc/traefik/traefik.yaml.gotmpl -d options=/data/options.json -o /etc/traefik/traefik.yaml
bashio::log.info "Static config generated"
