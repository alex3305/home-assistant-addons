ARG BUILD_FROM

FROM $BUILD_FROM
ENV LANG C.UTF-8

ARG BUILD_ARCH
ARG TRAEFIK_VERSION

COPY run.sh /
COPY traefik.yaml.j2 env.j2 /etc/traefik/

RUN apk add --no-cache python3 py3-pip && \
    pip3 install "j2cli[yaml]" && \
    wget --quiet -O /tmp/traefik.tar.gz "https://github.com/containous/traefik/releases/download/v${TRAEFIK_VERSION}/traefik_v${TRAEFIK_VERSION}_linux_${BUILD_ARCH}.tar.gz" && \
    tar xzvf /tmp/traefik.tar.gz -C /usr/local/bin traefik && \
    chmod a+x /usr/local/bin/traefik && \
    chmod a+x /run.sh && \
    rm -f /tmp/traefik.tar.gz

EXPOSE 80 443 8080
CMD [ "/run.sh" ]
