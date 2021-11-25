#!/bin/sh

set -e

mask=$(umask)
umask 077
cat dc.anvil_out/tailscale/*.env > dc.anvil_out/tailscale/.env
umask "$mask"
