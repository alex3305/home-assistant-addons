ARG BUILD_FROM

FROM $BUILD_FROM

ARG BW_CLI_VERSION

COPY run.sh /

RUN apk add --no-cache jq npm && \
    npm install --no-progress --no-audit -g @bitwarden/cli@${BW_CLI_VERSION} && \
    chmod +x run.sh

CMD [ "/run.sh" ]

LABEL \
    io.hass.name="Bitwarden Secrets for Home Assistant for ${BUILD_ARCH}" \
    io.hass.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Bitwarden secrets for Home Assistant image" \
    maintainer="Alex van den Hoogen <homeassistant@alxx.nl>" \
    org.opencontainers.image.title="Bitwarden Secrets for ${BUILD_ARCH}" \
    org.opencontainers.image.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Bitwarden secrets for Home Assistant image" \
    org.opencontainers.image.vendor="Alex van den Hoogen" \
    org.opencontainers.image.authors="Alex van den Hoogen <homeassistant@alxx.nl>" \
    org.opencontainers.image.url="https://alxx.nl/home-assistant-addons/" \
    org.opencontainers.image.source="https://alxx.nl/home-assistant-addons/" \
    org.opencontainers.image.documentation="https://alxx.nl/home-assistant-addons/blob/master/bitwarden-secrets/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
