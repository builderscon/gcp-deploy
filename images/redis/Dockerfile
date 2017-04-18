FROM redis:alpine

RUN apk add --update bind-tools curl && \
    rm -rf /var/cache/apk/* 
ADD bootstrap.sh /bootstrap.sh
VOLUME /conf
CMD ["redis-server", "/conf/redis.conf"]

