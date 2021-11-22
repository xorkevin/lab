#!/bin/sh

tailscale up --login-server {{ .Vars.server.headscale.url }} --qr
