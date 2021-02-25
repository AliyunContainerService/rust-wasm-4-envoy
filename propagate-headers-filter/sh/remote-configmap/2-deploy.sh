#!/usr/bin/env sh
SCRIPT_PATH="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)/"
cd "$SCRIPT_PATH" || exit

source config

alias k="kubectl --kubeconfig $USER_CONFIG"
alias m="kubectl --kubeconfig $MESH_CONFIG"

echo "clean..."
k delete namespace http-hello >/dev/null 2>&1
m delete namespace http-hello >/dev/null 2>&1
echo "create"
k create ns http-hello
m create ns http-hello
m label ns http-hello istio-injection=enabled

echo "deploy"
#部署数据平面
cd ../..
k -n http-hello apply -f config/kube/

echo "waiting for hello2-deploy-v1"
k -n http-hello wait --for=condition=ready pod -l app=hello2-deploy-v2
k -n http-hello wait --for=condition=ready pod -l app=hello1-deploy-v1

#查看服务状态
k get svc -n http-hello
#查看POD状态
k get pods -n http-hello

hello2_v1_pod=$(k get pod -l app=hello2-deploy-v1 -n http-hello -o jsonpath={.items..metadata.name})

echo "Check from $hello2_v1_pod:"
k exec "$hello2_v1_pod" -c hello-v1-deploy -n http-hello -- curl -s localhost:8001/hello/eric
echo
k exec "$hello2_v1_pod" -c hello-v1-deploy -n http-hello -- curl -s http://hello2-svc:8001/hello/eric
echo
k exec "$hello2_v1_pod" -c hello-v1-deploy -n http-hello -- curl -s http://hello1-svc:8001/hello/eric
echo

echo "Deploy mesh"
m -n http-hello apply -f config/mesh/
echo "Deploy wasm envoyfilter"
m -n http-hello apply -f config/envoyfilter/

#echo "Deploy lua envoyfilter"
#https://istio.io/latest/news/releases/1.9.x/announcing-1.9/upgrade-notes/
#m -n http-hello apply -f config/lua.envoyfilter/