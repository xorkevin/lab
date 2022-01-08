#!/bin/sh

set -e

ROOT=${0%/*}

docker exec tailscale-headscale-1 headscale "$@"
