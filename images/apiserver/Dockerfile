FROM alpine:3.4

RUN apk add --update ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*
ADD apiserver /apiserver

CMD /apiserver