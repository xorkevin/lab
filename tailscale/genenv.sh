#!/bin/sh

set -e

mask=$(umask)
umask 077
cat dc.run/env/*.env > dc.anvil_out/tailscale/.env
umask "$mask"
