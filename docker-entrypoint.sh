#!/bin/bash

groupadd --gid ${PGID} openssl
useradd --home-dir /data --no-create-home --uid ${PUID} --gid=${PGID} openssl

case $@ in
  shell)
    runuser -u openssl -- /bin/bash
    ;;

  *)
    runuser -u openssl -- /opt/ssl/bin/openssl $@
    ;;
esac
