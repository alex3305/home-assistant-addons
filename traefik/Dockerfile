ARG BUILD_FROM

FROM $BUILD_FROM

ARG BUILD_ARCH
ARG TRAEFIK_VERSION

COPY run.sh /

RUN if [ "${BUILD_ARCH}" == "aarch64" ]; then BUILD_ARCH=arm64; \
    elif [ "${BUILD_ARCH}" == "i386" ]; then BUILD_ARCH=386; \
    elif [ "${BUILD_ARCH}" == "armhf" ]; then BUILD_ARCH=armv7; \
    fi && \
    apk add --no-cache nginx gomplate && \
    wget --quiet -O /tmp/traefik.tar.gz "https://github.com/traefik/traefik/releases/download/v${TRAEFIK_VERSION}/traefik_v${TRAEFIK_VERSION}_linux_${BUILD_ARCH}.tar.gz" && \
    tar xzvf /tmp/traefik.tar.gz -C /usr/local/bin traefik && \
    chmod +x /usr/local/bin/traefik /run.sh && \
    rm -f /tmp/*

COPY traefik.yaml.gotmpl /etc/traefik/
COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD [ "/run.sh" ]

LABEL \
    io.hass.name="Treafik for ${BUILD_ARCH}" \
    io.hass.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Treafik image" \
    maintainer="Alex van den Hoogen <homeassistant@alxx.nl>" \
    org.opencontainers.image.title="Traefik for ${BUILD_ARCH}" \
    org.opencontainers.image.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Traefik image" \
    org.opencontainers.image.vendor="Alex van den Hoogen" \
    org.opencontainers.image.authors="Alex van den Hoogen <homeassistant@alxx.nl>" \
    org.opencontainers.image.url="https://alxx.nl/hassio-addons/" \
    org.opencontainers.image.source="https://alxx.nl/hassio-addons/" \
    org.opencontainers.image.documentation="https://alxx.nl/hassio-addons/blob/master/traefik/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
