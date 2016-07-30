FROM alpine:3.4

RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk add --update \
              musl \
              build-base \
              python \
              python-dev \
              py-pip \
  && rm /var/cache/apk/* \
  && pip2.7 install --upgrade pip \
  && pip install gunicorn

VOLUME [ "/static-files" ]
EXPOSE 5000
ADD conf.builderscon.io /conf.builderscon.io
ADD scripts/run.sh /
WORKDIR /conf.builderscon.io
RUN pip install -r requirements.txt
CMD [ "/run.sh" ]