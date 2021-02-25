#!/usr/bin/env sh
SCRIPT_PATH="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)/"
cd "$SCRIPT_PATH" || exit

source config
alias k="kubectl --kubeconfig $USER_CONFIG"

#k -n http-hello exec deployment/hello1-deploy-v2 -c istio-proxy -- ps aux

hello1_v2_pod=$(k get pod -l app=hello1-deploy-v2 -n http-hello -o jsonpath={.items..metadata.name})
k -n http-hello exec "$hello1_v2_pod" -c istio-proxy -- curl -XPOST -s "http://localhost:15000/logging?level=info"

k -n http-hello logs -f deployment/hello1-deploy-v2 -c istio-proxy