#!/usr/bin/env sh
# shellcheck disable=SC2028
SCRIPT_PATH="$(
    cd "$(dirname "$0")" >/dev/null 2>&1
    pwd -P
)/"
cd "$SCRIPT_PATH" || exit
source ../common/config
alias k="kubectl --kubeconfig $USER_CONFIG"
alias m="kubectl --kubeconfig $MESH_CONFIG"

PORT=38001
NS=hello-abtest-lua

echo "1 Deploy"
k get ns $NS
# exist return 0
# not exist return 1
RESULT=$?
if [[ $RESULT == 1 ]]; then
    sh ../common/deploy.sh $NS L
    m -n $NS apply -f gw$PORT.yaml
fi

echo "2 Verify"
ingressGatewayIp=$(k -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "curl -s -H \"route-v:v2\" http://$ingressGatewayIp:$PORT/hello/eric"
echo >result
for i in {1..5}; do
    curl -s -H "route-v:v1" "http://$ingressGatewayIp:$PORT/hello/eric" >>result
    echo >>result
done
# grep --only-matching
check=$(grep -o "Hello eric" result | wc -l)
rm -f result
if [[ "$check" -eq "15" ]]; then
    echo "pass"
else
    echo "fail"
    exit 1
fi
echo "3 Hey"
# https://github.com/rakyll/hey
hey -c $NUM -q $QPS -z $Duration -H "route-v:v2" http://$ingressGatewayIp:$PORT/hello/eric > $SIDECAR_LUA_RESULT
echo "DONE"
