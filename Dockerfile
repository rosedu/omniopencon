FROM debian:bookworm AS build

RUN set -xe ; \
    apt-get -yqq update ; \
    apt-get -yqq install wget \
    ;

ARG HUGO_VERSION=0.133.0

RUN set -xe ; \
    wget -q https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-amd64.deb ; \
    dpkg -i hugo_${HUGO_VERSION}_linux-amd64.deb \
    ;

CMD ["/usr/local/bin/hugo", "server", "--bind=0.0.0.0", "--source", "/site"]
