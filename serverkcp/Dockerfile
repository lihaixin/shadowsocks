#
# Dockerfile for shadowsocks-libev
#

FROM alpine:3.8
MAINTAINER EasyPi Software Foundation

ARG SS_VER=3.3.1
ARG KCPTUN_VERSION=20190515

ARG ARCH=amd64

ARG UDPSPEEDER_TAG_NAME=20180522.0
ARG UDPSPEEDER_FILE_NAME=speederv2_binaries.tar.gz
ARG UDPSPEEDER_DL_ADRESS="https://github.com/wangyu-/UDPspeeder/releases/download/$UDPSPEEDER_TAG_NAME/$UDPSPEEDER_FILE_NAME"
ARG UDPSPEEDER_BIN_NAME="speederv2_$ARCH"

ARG UDP2RAW_TAG_NAME=20180225.1
ARG UDP2RAW_FILE_NAME=udp2raw_binaries.tar.gz
ARG UDP2RAW_DL_ADRESS="https://github.com/wangyu-/udp2raw-tunnel/releases/download/$UDP2RAW_TAG_NAME/$UDP2RAW_FILE_NAME"
ARG UDP2RAW_BIN_NAME="udp2raw_$ARCH"

ENV TZ=Asia/Shanghai
WORKDIR /home
RUN apk add -U iproute2 && ln -s /usr/lib/tc /lib/tc
RUN set -ex \
    && apk add --no-cache c-ares \
                          libcrypto1.0 \
                          libev \
                          libsodium \
                          mbedtls \
                          tzdata \
                          curl \
                          pcre \
    && apk add --no-cache \
               --virtual TMP autoconf \
                             automake \
                             build-base \
                             c-ares-dev \
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
        && cd /home \
        && ln -s /usr/local/bin/ss-server /usr/local/bin/httpd-server \
        && wget $UDPSPEEDER_DL_ADRESS -O $UDPSPEEDER_FILE_NAME \
        && tar -zxvf $UDPSPEEDER_FILE_NAME \
        && find ./ -type f -not -name "$UDPSPEEDER_BIN_NAME" -delete \
        && mv "/home/$UDPSPEEDER_BIN_NAME" /usr/bin/speederv2 \
        && wget $UDP2RAW_DL_ADRESS -O $UDP2RAW_FILE_NAME \
        && tar -zxvf $UDP2RAW_FILE_NAME \
        && find ./ -type f -not -name "$UDP2RAW_BIN_NAME" -delete \
        && mv "/home/$UDP2RAW_BIN_NAME" /usr/bin/udp2raw-tunnel \
        && apk del TMP

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 61080
ENV METHOD      aes-256-gcm
ENV PASSWORD	pwd
ENV TIMEOUT     300
ENV DNS_ADDR    8.8.8.8
ENV OPTIONS	-v
ENV KCP_OPTIONS	--nocomp
ENV FEC_OPTIONS 2:4
ENV LIMIT_CONN 400
ENV RATE 50mbit

EXPOSE $SERVER_PORT/tcp
EXPOSE $SERVER_PORT/udp

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
