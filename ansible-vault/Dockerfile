ARG BUILD_FROM

FROM $BUILD_FROM

ARG ANSIBLE_VERSION

COPY run.sh /

RUN apk add --no-cache gcc git libffi-dev musl-dev openssl-dev perl && \
    python3 -m pip install ansible=="${ANSIBLE_VERSION}" && \
    chmod a+x /run.sh && \
    apk del --no-cache gcc libffi-dev musl-dev openssl-dev perl

CMD [ "/run.sh" ]

LABEL \
    io.hass.name="Ansible vault for ${BUILD_ARCH}" \
    io.hass.description="Home Assistant Unofficial Add-on: ${BUILD_ARCH} Ansible vault image" \
    maintainer="Alex van den Hoogen <homeassistant@alxx.nl>" \
    org.opencontainers.image.title="Ansible vault for ${BUILD_ARCH}" \
    org.opencontainers.image.description="Home Assistant Community Add-on: ${BUILD_ARCH} Ansible vault image" \
    org.opencontainers.image.vendor="Alex van den Hoogen" \
    org.opencontainers.image.authors="Alex van den Hoogen <homeassistant@alxx.nl>" \
    org.opencontainers.image.url="https://alxx.nl/home-assistant-addons/" \
    org.opencontainers.image.source="https://alxx.nl/home-assistant-addons/" \
    org.opencontainers.image.documentation="https://alxx.nl/home-assistant-addons/blob/master/ansible-vault/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
