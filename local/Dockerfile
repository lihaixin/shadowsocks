#
# Dockerfile for shadowsocks-libev
#

FROM alpine:3.8
MAINTAINER EasyPi Software Foundation

ARG SS_VER=3.3.1
ENV TZ=Asia/Shanghai

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
    && apk del TMP

ENV SERVER_ADDR=0.0.0.0
ENV SERVER_PORT=61080
ENV LOCAL_ADDR=0.0.0.0
ENV LOCAL_PORT=1080
ENV METHOD=xchacha20-ietf-poly1305
ENV PASSWORD=pwd
ENV TIMEOUT=300
ENV OPTIONS=-v

# EXPOSE $LOCAL_PORT/tcp

CMD ss-local  -s "$SERVER_ADDR" \
              -p "$SERVER_PORT" \
              -b "$LOCAL_ADDR" \
	      -l "$LOCAL_PORT" \
	      -m "$METHOD"      \
              -k "$PASSWORD"    \
              -t "$TIMEOUT"     \
              -u                \
              --fast-open $OPTIONS
