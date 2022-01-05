#!/bin/sh

name=$1
tags=$2

if [ -z "$name" ]; then
  printf "Must provide hostname\n"
  exit 1
fi

tailscale up --login-server '{{ .Vars.service.headscale.url }}' --qr --hostname="$name" --advertise-tags="$tags"
