FROM gcc:latest

ARG VERSION

RUN cd /usr/local/src \
  && wget -nv https://github.com/openssl/openssl/archive/refs/tags/openssl-${VERSION}.tar.gz \
  && tar -xvf openssl-${VERSION}.tar.gz \
  && cd openssl-openssl-${VERSION} \
  && ./Configure --prefix=/opt/ssl --openssldir=/opt/ssl no-weak-ssl-ciphers enable-fips

RUN cd /usr/local/src/openssl-openssl-${VERSION} && make

RUN cd /usr/local/src/openssl-openssl-${VERSION} && make test

RUN cd /usr/local/src/openssl-openssl-${VERSION} && make install

#---------------------------------------------

FROM debian:11-slim

ARG VERSION

ENV OPENSSL_FIPS=1

COPY --from=0 /opt/ssl /opt/ssl

RUN echo "/opt/ssl/lib64" > /etc/ld.so.conf.d/openssl-${VERSION}.conf \
  && ldconfig && /opt/ssl/bin/openssl version

VOLUME /data

WORKDIR /data

ENTRYPOINT [ "/opt/ssl/bin/openssl" ]
