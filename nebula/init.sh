#!/bin/sh

set -e

log2() {
  printf '[%s] %s\n' "$(date)" "$*" 1>&2
}

cacertdir=dc.run/cert/ca
if [ ! -e "$cacertdir/ca.key" ]; then
  log2 "No CA cert at $cacertdir"
  mkdir -p "$cacertdir"
  nebula-cert ca -name 'xorkevin-labs' -duration 87600h -out-key "$cacertdir/ca.key" -out-crt "$cacertdir/ca.crt"
  log2 "Wrote CA cert to $cacertdir"
else
  log2 "CA cert already present at $cacertdir"
fi

lhcertdir=dc.run/cert/lighthouse
if [ ! -e "$lhcertdir/host.key" ]; then
  log2 "No lighthouse host cert at $lhcertdir"
  mkdir -p "$lhcertdir"
  nebula-cert sign \
    -ca-key "$cacertdir/ca.key" -ca-crt "$cacertdir/ca.crt" \
    -name 'lighthouse1.xorkevin.lan' -ip '172.16.127.1/24' \
    -groups 'lighthouses' \
    -out-key "$lhcertdir/host.key" -out-crt "$lhcertdir/host.crt"
  log2 "Wrote lighthouse host cert to $lhcertdir"
else
  log2 "Lighthouse host cert already present at $lhcertdir"
fi
