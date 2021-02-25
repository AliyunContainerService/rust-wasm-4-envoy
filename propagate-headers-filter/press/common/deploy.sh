#!/usr/bin/env sh
SCRIPT_PATH="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)/"
cd "$SCRIPT_PATH" || exit
if [ -z "$1" ]; then
  echo "No namespace argument supplied"
  exit 0
fi
NS=$1
# S sidecar
# W wasm-sidecar
# L lua-sidecar
TYPE=$2

source config
alias k="kubectl --kubeconfig $USER_CONFIG"
alias m="kubectl --kubeconfig $MESH_CONFIG"

echo "Clean..."
k delete namespace $NS >/dev/null 2>&1
m delete namespace $NS >/dev/null 2>&1
echo "Create namespace($NS)"
k create ns $NS
m create ns $NS
m label ns $NS istio-injection=enabled

echo "Deploy dataplane"
cd ../..
k -n $NS apply -f config/kube/

echo " Waiting for hello2-deploy-v1"
k -n $NS wait --for=condition=ready pod -l app=hello2-deploy-v2
k -n $NS wait --for=condition=ready pod -l app=hello1-deploy-v1
sleep 3s
k get svc -n $NS
k get pods -n $NS

hello2_v1_pod=$(k get pod -l app=hello2-deploy-v1 -n $NS -o jsonpath={.items..metadata.name})

echo "Check from hello2v1($hello2_v1_pod):"
k exec "$hello2_v1_pod" -c hello-v1-deploy -n $NS -- curl -s localhost:8001/hello/eric
echo
k exec "$hello2_v1_pod" -c hello-v1-deploy -n $NS -- curl -s http://hello2-svc:8001/hello/eric
echo
k exec "$hello2_v1_pod" -c hello-v1-deploy -n $NS -- curl -s http://hello1-svc:8001/hello/eric
echo

echo "Deploy mesh"
case $TYPE in
"S")
  m -n $NS apply -f config/mesh/
  echo "DONE"
  ;;
"W")
  m -n $NS apply -f config/mesh/
  echo "Deploy wasm envoyfilter"
  m -n $NS apply -f config/envoyfilter/
  echo "Deploy wasm configmap"
  wasm_image=target/wasm32-unknown-unknown/release/propaganda-header-filter.wasm
  k -n $NS create configmap -n $NS propaganda-header --from-file=$wasm_image
  echo "Patch annotations to deployment"
  patch_annotations=$(cat config/annotations/patch-annotations.yaml)
  for i in {1..2}; do
    for j in {2..2}; do
      k -n $NS patch deployment "hello$i-deploy-v$j" -p "$patch_annotations"
    done
  done
  ;;
"L")
  m -n $NS apply -f config/mesh/
  echo "Deploy lua envoyfilter"
  # https://istio.io/latest/news/releases/1.9.x/announcing-1.9/upgrade-notes/
  m -n $NS apply -f config/lua.envoyfilter/
  ;;
*)
  echo "DONE"
  ;;
esac
