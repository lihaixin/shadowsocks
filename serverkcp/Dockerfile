#
# Dockerfile for shadowsocks-libev
#

FROM alpine:3.8
MAINTAINER EasyPi Software Foundation

ARG SS_VER=3.3.1
ARG KCPTUN_VERSION=20190515


RUN set -ex \
    && apk add --no-cache c-ares \
                          libcrypto1.0 \
                          libev \
                          libsodium \
                          mbedtls \
                          pcre \
    && apk add --no-cache \
               --virtual TMP autoconf \
                             automake \
                             build-base \
                             c-ares-dev \
                             curl \
                             gettext-dev \
                             libev-dev \
                             libsodium-dev \
                             libtool \
                             linux-headers \
                             mbedtls-dev \
                             openssl-dev \
                             pcre-dev \
                             tar \
    && curl -sSL https://github.com/shadowsocks/shadowsocks-libev/archive/v$SS_VER.tar.gz | tar xz \
    && cd shadowsocks-libev-$SS_VER \
        && curl -sSL https://github.com/shadowsocks/ipset/archive/shadowsocks.tar.gz | tar xz --strip 1 -C libipset \
        && curl -sSL https://github.com/shadowsocks/libcork/archive/shadowsocks.tar.gz | tar xz --strip 1 -C libcork \
        && curl -sSL https://github.com/shadowsocks/libbloom/archive/master.tar.gz | tar xz --strip 1 -C libbloom \
        && curl -sSL https://github.com/xtaci/kcptun/releases/download/v${KCPTUN_VERSION}/kcptun-linux-amd64-${KCPTUN_VERSION}.tar.gz | tar xz -C /usr/local/bin \
        && ./autogen.sh \
        && ./configure --disable-documentation \
        && make install \
        && cd .. \
        && rm -rf shadowsocks-libev-$SS_VER \
    && apk del TMP \
    && ln -s /usr/local/bin/ss-server /usr/local/bin/httpd-server

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 61080
ENV METHOD      chacha20-ietf-poly1305
ENV PASSWORD	pwd
ENV TIMEOUT     300
ENV DNS_ADDR    8.8.8.8
ENV OPTIONS	-v
ENV KCP_OPTIONS	--nocomp

EXPOSE $SERVER_PORT/tcp
EXPOSE $SERVER_PORT/udp


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
