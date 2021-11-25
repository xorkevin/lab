#!/bin/sh

set -e

log2() {
  printf '[%s] %s\n' "$(date)" "$*" 1>&2
}

gen_pass() {
  local passlen=$1
  head -c "$passlen" < /dev/urandom | base64 | tr -d '\n=' | tr '+/' '-_'
}

headscalekey=dc.anvil/headscale.key
if [ ! -e "$headscalekey" ]; then
  log2 "No headscale wireguard key at $headscalekey"
  mask=$(umask)
  umask 077
  wg genkey > "$headscalekey"
  umask "$mask"
  log2 "Wrote wireguard key to $headscalekey"
else
  log2 "Headscale wireguard key already present at $headscalekey"
fi

pgpassenv=dc.anvil/labpgpass.env
if [ ! -e "$pgpassenv" ]; then
  log2 "No postgres pass env at $pgpassenv"
  pgpass=$(gen_pass 64)

  mask=$(umask)
  umask 077
  cat <<EOF > "$pgpassenv"
POSTGRES_PASSWORD="$pgpass"
EOF
  umask "$mask"
  log2 "Wrote postgres pass to $pgpassenv"
else
  log2 "Postgres pass env already present at $pgpassenv"
fi

testcertdir=dc.anvil/derpcert
if [ ! -d "$testcertdir" ]; then
  log2 "No test DERP TLS cert at $testcertdir"
  mkdir -p "$testcertdir"
  openssl req -x509 \
    -newkey rsa:2048 -sha256 -nodes -days 365 -extensions 'v3_req' \
    -subj '/CN=localhost' -addext 'subjectAltName = DNS:localhost' \
    -outform PEM -keyout "$testcertdir/localhost.key" -out "$testcertdir/localhost.crt"
  log2 "Wrote test DERP TLS cert to $testcertdir"
else
  log2 "Test DERP TLS cert already present at $testcertdir"
fi

log2 "Mkdir dc.run/headscale"
mkdir -p dc.run/headscale
log2 "Mkdir dc.run/derper"
mkdir -p dc.run/derper
