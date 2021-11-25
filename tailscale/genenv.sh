#!/bin/sh

set -e

mask=$(umask)
umask 077
cat dc.anvil_out/lab/*.env > dc.anvil_out/lab/.env
umask "$mask"
