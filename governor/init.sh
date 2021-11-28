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
POSTGRES_PASSWORD='$pgpass'
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
REDIS_PASSWORD='$redispass'
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
MINIO_SECRET='$miniosecret'
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
NATS_TOKEN='$natstoken'
EOF
  umask "$mask"
  log2 "Wrote nats token to $natstokenenv"
else
  log2 "NATS token env already present at $natstokenenv"
fi

govsetupsecretenv="$envdir/govsetupsecret.env"
if [ ! -e "$govsetupsecretenv" ]; then
  log2 "No gov setup secret env at $govsetupsecretenv"
  govsetupsecret=$(gen_pass 64)
  mask=$(umask)
  umask 077
  cat <<EOF > "$govsetupsecretenv"
GOV_SETUP_SECRET='$govsetupsecret'
EOF
  umask "$mask"
  log2 "Wrote gov setup secret to $govsetupsecretenv"
else
  log2 "Gov setup secret env already present at $govsetupsecretenv"
fi

govmailkeyenv="$envdir/govmailkey.env"
if [ ! -e "$govmailkeyenv" ]; then
  log2 "No gov mailkey env at $govmailkeyenv"
  govmailkey=$(gen_pass 32)
  mask=$(umask)
  umask 077
  cat <<EOF > "$govmailkeyenv"
GOV_MAILKEY='\$cc20p\$$govmailkey'
EOF
  umask "$mask"
  log2 "Wrote gov mailkey to $govmailkeyenv"
else
  log2 "Gov mailkey env already present at $govmailkeyenv"
fi

govtokensecretenv="$envdir/govtokensecret.env"
if [ ! -e "$govtokensecretenv" ]; then
  log2 "No gov token secret env at $govtokensecretenv"
  govtokensecret=$(gen_pass 64)
  mask=$(umask)
  umask 077
  cat <<EOF > "$govtokensecretenv"
GOV_TOKEN_SECRET='$govtokensecret'
EOF
  umask "$mask"
  log2 "Wrote gov token secret to $govtokensecretenv"
else
  log2 "Gov token secret env already present at $govtokensecretenv"
fi

govotpkeyenv="$envdir/govotpkey.env"
if [ ! -e "$govotpkeyenv" ]; then
  log2 "No gov otpkey env at $govotpkeyenv"
  govotpkey=$(gen_pass 32)
  mask=$(umask)
  umask 077
  cat <<EOF > "$govotpkeyenv"
GOV_OTPKEY='\$cc20p\$$govotpkey'
EOF
  umask "$mask"
  log2 "Wrote gov otpkey to $govotpkeyenv"
else
  log2 "Gov otpkey env already present at $govotpkeyenv"
fi

govrsakeyfile="$envdir/govrsakey.key"
if [ ! -e "$govrsakeyfile" ]; then
  log2 "No gov rsa key file at $govrsakeyfile"
  govrsakey=$(gen_pass 32)
  mask=$(umask)
  umask 077
  openssl genpkey -algorithm RSA -pkeyopt "rsa_keygen_bits:4096" > "$govrsakeyfile"
  umask "$mask"
  log2 "Wrote gov rsa key to $govrsakeyfile"
else
  log2 "Gov rsa key file already present at $govrsakeyfile"
fi
