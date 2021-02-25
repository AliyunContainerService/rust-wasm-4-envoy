#!/usr/bin/env sh
# shellcheck disable=SC2028
SCRIPT_PATH="$(
    cd "$(dirname "$0")" >/dev/null 2>&1
    pwd -P
)"
cd "$SCRIPT_PATH" || exit

MAX_OPENFILE_NUM=50000
ulimit -n $MAX_OPENFILE_NUM

run_press() {
    RESULT_PATH="$SCRIPT_PATH/_result/$NUM-$QPS-$Duration/"
    echo "run_press(NUM=$NUM,QPS=$QPS,Duration=$Duration)\nsave to $RESULT_PATH"
    export SIDECAR_RESULT=$RESULT_PATH/sidecar.result
    export SIDECAR_WASM_RESULT=$RESULT_PATH/wasm-sidecar.result
    export SIDECAR_LUA_RESULT=$RESULT_PATH/lua-sidecar.result
    test -d $RESULT_PATH || mkdir -p $RESULT_PATH
    sh sidecar/press.sh
    sh wasm-sidecar/press.sh
    sh lua-sidecar/press.sh
}

export NUM=2000
export QPS=2000
export Duration=10s
run_press
