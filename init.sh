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

labenv=dc.anvil/lab.env
if [ ! -e "$labenv" ]; then
  log2 "No lab env at $labenv"
  pgpass=$(gen_pass 64)

  mask=$(umask)
  umask 077
  cat <<EOF > "$labenv"
POSTGRES_PASSWORD="$pgpass"
EOF
  umask "$mask"
  log2 "Wrote postgres pass to $labenv"
else
  log2 "Lab env already present at $labenv"
fi
