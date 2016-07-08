FROM alpine:3.4

RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk add --update \
              musl \
              build-base \
              python3 \
              python3-dev \
  && pip3.5 install --upgrade pip \
  && rm /var/cache/apk/* \
  && cd /usr/bin \
  && ln -sf easy_install-3.5 easy_install \
  && ln -sf idle3.5 idle \
  && ln -sf pydoc3.5 pydoc \
  && ln -sf python3.5 python \
  && ln -sf python-config3.5 python-config \
  && ln -sf pip3.5 pip \
  && pip install jinja2 requests bottle redis gunicorn

VOLUME [ "/static-files" ]
EXPOSE 5000
ADD conf.builderscon.io /conf.builderscon.io
ADD scripts/run.sh /
WORKDIR /conf.builderscon.io
CMD [ "/run.sh" ]