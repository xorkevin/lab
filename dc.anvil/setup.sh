#!/bin/sh

set -e

log2() {
  printf '[%s] %s\n' "$(date)" "$*" 1>&2
}

for i in $(cat /etc/headscale/nslist.txt); do
  log2 "Create ns $i"
  headscale namespaces create "$i"
done
