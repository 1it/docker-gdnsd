FROM alpine:latest as builder

ENV VERSION=3.2.2

RUN apk add --no-cache \
            autoconf \
            automake \
            bison \
            curl \
            file \
            flex \
            gawk \
            gcc \
            geoip-dev \
            git \
            gnupg \
            libc-dev \
            libev-dev \
            libmaxminddb-dev \
            libsodium-dev \
            libtool \
            make \
            openssl-dev \
            patch \
            pcre-dev \
            perl \
            perl-test-pod-doc \
            ragel \
            userspace-rcu-dev \
            zlib-dev

RUN mkdir -p /usr/src \
    && cd /usr/src \
    && curl -sSL https://github.com/gdnsd/gdnsd/releases/download/v${VERSION}/gdnsd-${VERSION}.tar.xz | tar -xJ \
    && cd gdnsd-$VERSION \
    && autoreconf -vif \
    && ./configure --prefix=/usr --sysconfdir=/etc \
    && make all install

FROM alpine:latest

RUN apk add --no-cache \
            libev \
            libmaxminddb \
            libsodium \
            musl \
            userspace-rcu

RUN addgroup -S gdnsd && adduser -D -S -h /var/run/gdnsd -s /sbin/nologin -G gdnsd gdnsd

RUN mkdir -p /etc/gdnsd \
             /etc/gdnsd/zones \
             /etc/gdnsd/geoip \
             /usr/var/run/gdnsd \
             /usr/var/lib/gdnsd

COPY --from=builder /usr/sbin/gdnsd /usr/sbin/gdnsd
COPY --from=builder /usr/bin/gdnsdctl /usr/bin/gdnsdctl

EXPOSE 53/tcp 53/udp

CMD ["/usr/sbin/gdnsd", "start"]
