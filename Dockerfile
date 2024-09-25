FROM docker.io/library/busybox:1.36.1-glibc
ENV TZ=Asia/Shanghai \
    PORT=8886 \
    VUID=0
WORKDIR /app
COPY verysync-linux-amd64-*/verysync /tmp/
COPY docker-entrypoint.sh /app

RUN chmod 0755 /tmp/verysync \
    && mv /tmp/verysync /usr/bin/ \
    && mkdir -p /data/ \
    && chmod 0775 /data/ \
    && addgroup -S nonverysync && adduser -S nonverysync -G nonverysync \
    && chmod 0755 /app/docker-entrypoint.sh

RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.17/gosu-amd64" \
    && chmod 0755 /usr/local/bin/gosu \
    && gosu nobody true

HEALTHCHECK --interval=1m --timeout=10s \
  CMD nc -z 127.0.0.1 ${PORT}  || exit 1

ENTRYPOINT ["/app/docker-entrypoint.sh"]
