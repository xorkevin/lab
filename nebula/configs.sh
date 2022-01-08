#!/bin/sh

set -e

log2() {
  printf '[%s] %s\n' "$(date)" "$*" 1>&2
}

cacertdir=dc.run/cert/ca
if [ ! -e "$cacertdir/ca.key" ]; then
  log2 "No CA cert at $cacertdir"
  mkdir -p "$cacertdir"
  nebula-cert ca -name 'xorkevin-labs' -duration 87600h -out-key "$cacertdir/ca.key" -out-crt "$cacertdir/ca.crt"
  log2 "Wrote CA cert to $cacertdir"
else
  log2 "CA cert already present at $cacertdir"
fi

hostsfile=dc.anvil_out/nebula/hosts.json
configsdir=dc.anvil_out/nebula/configs
for i in $(cat "$hostsfile" | jq '.hosts | keys[]'); do
  name=$(cat "$hostsfile" | jq -r --argjson idx "$i" '.hosts[$idx].name')
  hostip=$(cat "$hostsfile" | jq -r --argjson idx "$i" '.hosts[$idx].ip')
  kind=$(cat "$hostsfile" | jq -r --argjson idx "$i" '.hosts[$idx].kind')
  groups=$(cat "$hostsfile" | jq -r --argjson idx "$i" '.hosts[$idx].groups')
  hostdir=dc.run/nebulaetc/$name
  mkdir -p "$hostdir"
  if [ ! -e "$hostdir/host.key" ]; then
    log2 "No host cert for $name at $hostdir"
    nebula-cert sign \
      -ca-key "$cacertdir/ca.key" -ca-crt "$cacertdir/ca.crt" \
      -name "$name.xorkevin.lan" -ip "$hostip" -groups "$groups" \
      -out-key "$hostdir/host.key" -out-crt "$hostdir/host.crt"
    log2 "Wrote host cert for $name $hostip with groups $groups to $hostdir"
  else
    log2 "Host cert for $name already present at $hostdir"
  fi
  cp "$cacertdir/ca.crt" "$hostdir/ca.crt"
  cp "$configsdir/$kind.yaml" "$hostdir/config.yaml"
done
