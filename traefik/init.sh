#!/bin/sh

set -e

log2() {
  printf '[%s] %s\n' "$(date)" "$*" 1>&2
}

log2 "Mkdir dc.run/traefik"
mkdir -p dc.run/traefik
