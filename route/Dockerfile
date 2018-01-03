#
# Dockerfile for shadowsocks-libev
#

FROM alpine
MAINTAINER EasyPi Software Foundation

ENV SS_VER 3.1.1
ENV SS_URL https://github.com/shadowsocks/shadowsocks-libev/archive/v$SS_VER.tar.gz
ENV SS_DIR shadowsocks-libev-$SS_VER

RUN set -ex \
    && apk add --no-cache c-ares \
                          libcrypto1.0 \
                          libev \
                          libsodium \
                          mbedtls \
                          pcre iptables iproute2 curl drill ipset openssh-client \
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
    && curl -sSL $SS_URL | tar xz \
    && cd $SS_DIR \
        && curl -sSL https://github.com/shadowsocks/ipset/archive/shadowsocks.tar.gz | tar xz --strip 1 -C libipset \
        && curl -sSL https://github.com/shadowsocks/libcork/archive/shadowsocks.tar.gz | tar xz --strip 1 -C libcork \
        && curl -sSL https://github.com/shadowsocks/libbloom/archive/master.tar.gz | tar xz --strip 1 -C libbloom \
        && ./autogen.sh \
        && ./configure --disable-documentation \
        && make install \
        && cd .. \
        && rm -rf $SS_DIR \
    && apk del TMP

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 61080
ENV LOCAL_ADDR      0.0.0.0
ENV LOCAL_PORT      60080
ENV LOCAL_NET	192.168.3.0/24
ENV METHOD      chacha20-ietf-poly1305
ENV PASSWORD	pwd
ENV TIMEOUT     300
ENV OPTIONS         -v

ADD ./run-route /
RUN chmod +x /run-route

CMD ["/run-route"]
