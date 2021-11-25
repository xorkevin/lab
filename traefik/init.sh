#!/bin/sh

set -e

log2() {
  printf '[%s] %s\n' "$(date)" "$*" 1>&2
}

acmedir=dc.run/traefik/letsencrypt
acmefile="$acmedir/acme.json"
if [ ! -e "$acmefile" ]; then
  log2 "No acme file at $acmefile"
  mkdir -p "$acmedir"
  mask=$(umask)
  umask 077
  touch "$acmefile"
  umask "$mask"
  log2 "Created acme file at $acmefile"
else
  log2 "ACME file already present at $acmefile"
fi
