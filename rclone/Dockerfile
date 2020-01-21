ARG BUILD_FROM

FROM $BUILD_FROM
ENV LANG C.UTF-8

ARG BUILD_VERSION

COPY run.sh /

RUN apk add --no-cache unzip findutils && \
    wget --quiet -O /tmp/rclone.zip https://downloads.rclone.org/v${BUILD_VERSION}/rclone-v${BUILD_VERSION}-linux-amd64.zip && \
    unzip /tmp/rclone.zip -d /tmp && \
    cp /tmp/rclone-v${BUILD_VERSION}-linux-amd64/rclone /usr/bin/rclone && \
    chmod a+x /usr/bin/rclone && \
    chmod a+x /run.sh && \
    rm -rf /tmp/*

CMD [ "/run.sh" ]
