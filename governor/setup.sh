#!/bin/sh

set -e

bin=$1

. dc.anvil_out/governor/.env

"$bin" setup --config dc.anvil_out/governor/client.yaml --secret "$GOV_SETUP_SECRET"
