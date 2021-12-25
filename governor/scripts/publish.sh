#!/bin/sh

set -e

ROOT=${0%/*}

envfile="$ROOT/../dc.run/docker-compose.env"
if [ ! -e "$envfile" ]; then
  printf "No env file\n"
  exit 2
fi

. "$envfile"

subject=$1
payload=$2

if [ -z "$subject" ]; then
  printf "Must provide subject\n"
  exit 1
fi

if [ -z "$payload" ]; then
  printf "Must provide payload\n"
  exit 1
fi

curl --user "system:${GOV_EVENTS_API_SECRET}" --request POST "http://localhost:8080/api/events/publish?subject=$subject" --data-raw "$payload"
