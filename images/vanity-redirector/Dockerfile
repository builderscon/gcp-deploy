FROM alpine:3.4

ENV PERL_CPANM_OPT "-n --no-wget"
ADD cpanm /usr/local/bin
RUN apk add --update \
  ca-certificates \
  build-base \
  perl \
  perl-dev \
  && rm /var/cache/apk/* \
  && cpanm Carton

ADD cpanfile /app/cpanfile

WORKDIR /app
RUN cpanm --installdeps .

ADD app.psgi /app/app.psgi
ADD run.sh /app/run.sh

CMD /app/run.sh
