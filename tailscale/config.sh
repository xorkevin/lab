#!/usr/bin/env bash

set -e

log2() {
  printf '[%s] %s\n' "$(date)" "$*" 1>&2
}

envdir=dc.run/env
oidcenv="$envdir/oidcclient.env"
if [ ! -e "$oidcenv" ]; then
  log2 "No OIDC config at $oidcenv"
  mkdir -p "$envdir"
  printf "Set OIDC client\n"
  read -ep 'client id: ' clientid
  read -sp 'client secret: ' clientsecret; printf '\n'

  mask=$(umask)
  umask 077
  cat <<EOF > "$oidcenv"
OIDC_CLIENT_ID="$clientid"
OIDC_CLIENT_SECRET="$clientsecret"
EOF
  umask "$mask"
  log2 "Wrote OIDC config to $oidcenv"
else
  log2 "OIDC config already present at $oidcenv"
fi
