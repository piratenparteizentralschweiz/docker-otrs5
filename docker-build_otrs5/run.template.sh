#!/bin/bash

docker stop otrs
docker rm otrs
docker run -d \
  --name=otrs \
  -e OTRS_DB_HOST=172.17.0.1 \
  -e OTRS_DB_NAME=otrs \
  -e OTRS_DB_USER=otrs \
  -e OTRS_DB_PASS=secret \
  -v /otrs_data/gnupg:/opt/otrs/.gnupg \
  -p 5002:80 \
  exception/otrs \
  $1


