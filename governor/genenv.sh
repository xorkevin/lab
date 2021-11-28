#!/bin/sh

set -e

envfile=dc.anvil_out/governor/.env

mask=$(umask)
umask 077
cat dc.run/env/*.env > "$envfile"
umask "$mask"

etcdir=dc.anvil_out/governor/govetc
secretsfile="$etcdir/secrets.yaml"

mkdir -p "$etcdir"

. "$envfile"

mask=$(umask)
umask 077
cat <<EOF > "$secretsfile"
data:
  setupsecret:
    secret: "${GOV_SETUP_SECRET}"
  dbauth:
    username: postgres
    password: "${POSTGRES_PASSWORD}"
  kvauth:
    password: "${REDIS_PASSWORD}"
  objauth:
    username: admin
    password: "${MINIO_SECRET}"
  eventsauth:
    password: "${NATS_TOKEN}"
  mailauth:
    username: "${GOV_MAIL_USERNAME}"
    password: "${GOV_MAIL_PASSWORD}"
  mailkey:
    secrets:
      - "${GOV_MAILKEY}"
  tokensecret:
    secret: "${GOV_TOKEN_SECRET}"
  otpkey:
    secrets:
      - "${GOV_OTPKEY}"
  rsakey:
    secret: |
EOF
cat dc.run/env/govrsakey.key | sed 's/^/      /' >> "$secretsfile"
umask "$mask"
