#!/usr/bin/env sh

# shellcheck disable=SC2016

SCRIPT_PATH="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)/"
cd "$SCRIPT_PATH" || exit
cd ../..

##
sha_256=$(cat target/wasm32-unknown-unknown/release/propaganda-filter.sha256)
host_ip=$(ipconfig getifaddr en0)
cp envoy/envoy-remote-wasm.yaml.template envoy/envoy-remote-wasm.yaml

sed -i "" "s#HOST_IP#$host_ip#g" envoy/envoy-remote-wasm.yaml
sed -i "" "s#SHA_256#$sha_256#g" envoy/envoy-remote-wasm.yaml

##
cd target/wasm32-unknown-unknown/release/

##
python3 -m http.server