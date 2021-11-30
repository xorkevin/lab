#!/bin/sh

set -e

envfile=dc.run/docker-compose.env
if [ -e "$envfile" ]; then
  rm "$envfile"
fi
mask=$(umask)
umask 077
cat dc.run/env/*.env > "$envfile"
umask "$mask"
