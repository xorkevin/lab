#!/bin/sh

tailscale up --login-server '{{ .Vars.service.headscale.url }}' --qr
