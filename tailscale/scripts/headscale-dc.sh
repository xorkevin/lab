#!/bin/sh

set -e

ROOT=${0%/*}

docker exec tailscale_headscale_1 headscale "$@"
