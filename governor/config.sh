#!/usr/bin/env bash

set -e

log2() {
  printf '[%s] %s\n' "$(date)" "$*" 1>&2
}

envdir=dc.run/env
mailclientenv="$envdir/mailclient.env"
if [ ! -e "$mailclientenv" ]; then
  log2 "No mail client config at $mailclientenv"
  mkdir -p "$envdir"
  printf "Set mail client\n"
  read -ep 'username: ' username
  read -sp 'password: ' password; printf '\n'

  mask=$(umask)
  umask 077
  cat <<EOF > "$mailclientenv"
GOV_MAIL_USERNAME="$username"
GOV_MAIL_PASSWORD="$password"
EOF
  umask "$mask"
  log2 "Wrote mail client config to $mailclientenv"
else
  log2 "Mail client config already present at $mailclientenv"
fi
