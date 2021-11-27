#!/bin/sh

set -e

log2() {
  printf '[%s] %s\n' "$(date)" "$*" 1>&2
}

gen_pass() {
  local passlen=$1
  head -c "$passlen" < /dev/urandom | base64 | tr -d '\n=' | tr '+/' '-_'
}

envdir=dc.run/env
mkdir -p "$envdir"

pgpassenv="$envdir/pgpass.env"
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

redispassenv="$envdir/redispass.env"
if [ ! -e "$redispassenv" ]; then
  log2 "No redis pass env at $redispassenv"
  redispass=$(gen_pass 64)
  mask=$(umask)
  umask 077
  cat <<EOF > "$redispassenv"
REDIS_PASSWORD="$redispass"
EOF
  umask "$mask"
  log2 "Wrote redis pass to $redispassenv"
else
  log2 "Redis pass env already present at $redispassenv"
fi

miniosecretenv="$envdir/miniosecret.env"
if [ ! -e "$miniosecretenv" ]; then
  log2 "No minio secret env at $miniosecretenv"
  miniosecret=$(gen_pass 64)
  mask=$(umask)
  umask 077
  cat <<EOF > "$miniosecretenv"
MINIO_SECRET="$miniosecret"
EOF
  umask "$mask"
  log2 "Wrote minio secret to $miniosecretenv"
else
  log2 "Minio secret env already present at $miniosecretenv"
fi

natstokenenv="$envdir/natstoken.env"
if [ ! -e "$natstokenenv" ]; then
  log2 "No nats token env at $natstokenenv"
  natstoken=$(gen_pass 64)
  mask=$(umask)
  umask 077
  cat <<EOF > "$natstokenenv"
NATS_TOKEN="$natstoken"
EOF
  umask "$mask"
  log2 "Wrote nats token to $natstokenenv"
else
  log2 "NATS token env already present at $natstokenenv"
fi
