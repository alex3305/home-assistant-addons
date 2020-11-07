ARG BUILD_FROM

FROM $BUILD_FROM

COPY run.sh /

RUN apk add --no-cache jq npm && \
    npm install -g --no-progress @bitwarden/cli && \
    chmod +x run.sh

CMD [ "/run.sh" ]

LABEL \
    io.hass.name="Bitwarden Secrets for ${BUILD_ARCH}" \
    io.hass.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Bitwarden Secrets image" \
    maintainer="Alex van den Hoogen <homeassistant@alxx.nl>" \
    org.opencontainers.image.title="Bitwarden Secrets for ${BUILD_ARCH}" \
    org.opencontainers.image.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Bitwarden Secrets image" \
    org.opencontainers.image.vendor="Alex van den Hoogen" \
    org.opencontainers.image.authors="Alex van den Hoogen <homeassistant@alxx.nl>" \
    org.opencontainers.image.url="https://alxx.nl/hassio-addons/" \
    org.opencontainers.image.source="https://alxx.nl/hassio-addons/" \
    org.opencontainers.image.documentation="https://alxx.nl/hassio-addons/blob/master/bitwarden-secrets/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}