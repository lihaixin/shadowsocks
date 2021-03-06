#
# Dockerfile for shadowsocks-libev
#

FROM alpine:3.8
MAINTAINER EasyPi Software Foundation

ARG SS_VER=3.3.4
ENV TZ=Asia/Shanghai


RUN apk add -U iproute2 && ln -s /usr/lib/tc /lib/tc
RUN set -ex \
    && apk add --no-cache c-ares \
                          libcrypto1.0 \
                          libev \
                          libsodium \
                          mbedtls \
                          tzdata \
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
        && ./autogen.sh \
        && ./configure --disable-documentation \
        && make install \
        && cd .. \
        && rm -rf shadowsocks-libev-$SS_VER \
    && apk del TMP \
    && ln -s /usr/local/bin/ss-server /usr/local/bin/httpd-server

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 61080
ENV METHOD      xchacha20-ietf-poly1305
ENV PASSWORD	pwd
ENV TIMEOUT     300
ENV DNS_ADDR    8.8.8.8
ENV OPTIONS	-v

EXPOSE $SERVER_PORT/tcp
EXPOSE $SERVER_PORT/udp


ENV LIMIT_PORT 61080
ENV LIMIT_CONN 40
ENV RATE 20mbit
ENV BURST 100kb
ENV LATENCY 50ms
ENV INTERVAL 60

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
