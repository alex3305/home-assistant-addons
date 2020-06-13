ARG BUILD_FROM

FROM $BUILD_FROM

ARG RCLONE_VERSION

COPY run.sh /

RUN apk add --no-cache unzip findutils && \
    wget --quiet -O /tmp/rclone.zip https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-amd64.zip && \
    unzip /tmp/rclone.zip -d /tmp && \
    cp /tmp/rclone-v${RCLONE_VERSION}-linux-amd64/rclone /usr/bin/rclone && \
    chmod a+x /usr/bin/rclone && \
    chmod a+x /run.sh && \
    rm -rf /tmp/*

CMD [ "/run.sh" ]

LABEL \
    io.hass.name="Rclone for ${BUILD_ARCH}" \
    io.hass.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Rclone image" \
    maintainer="Alex van den Hoogen <homeassistant@alxx.nl>" \
    org.opencontainers.image.title="Rclone for ${BUILD_ARCH}" \
    org.opencontainers.image.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Rclone image" \
    org.opencontainers.image.vendor="Alex van den Hoogen" \
    org.opencontainers.image.authors="Alex van den Hoogen <homeassistant@alxx.nl>" \
    org.opencontainers.image.url="https://alxx.nl/hassio-addons/" \
    org.opencontainers.image.source="https://alxx.nl/hassio-addons/" \
    org.opencontainers.image.documentation="https://alxx.nl/hassio-addons/blob/master/rclone/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
