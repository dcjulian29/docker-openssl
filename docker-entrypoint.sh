#!/bin/bash

addgroup -gid ${PGID} openssl > /dev/null 2>&1
adduser --home /data --no-create-home --uid ${PUID} --gid=${PGID} \
  --disabled-password --gecos "First,Last,RoomNumber,WorkPhone,HomePhone" openssl > /dev/null 2>&1

case $@ in
  shell)
    runuser -u openssl -- /bin/bash
    ;;

  *)
    runuser -u openssl -- /opt/ssl/bin/openssl $@
    ;;
esac
