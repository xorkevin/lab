#!/bin/sh

tailscale up --login-server '{{ .Vars.service.headscale.url }}' --shields-up --qr
