FROM debian:bookworm AS build

RUN set -xe ; \
    apt-get -yqq update ; \
    apt-get -yqq install wget ca-certificates ; \
    rm -rf /var/lib/apt/lists/* \
    ;

ARG HUGO_VERSION=0.133.0

# The "extended" build is required for image processing (WebP) used by the site.
RUN set -xe ; \
    wget -q https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb ; \
    dpkg -i hugo_extended_${HUGO_VERSION}_linux-amd64.deb ; \
    rm -f hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
    ;

WORKDIR /site

CMD ["hugo", "server", "--bind=0.0.0.0", "--noBuildLock"]
