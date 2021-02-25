#!/usr/bin/env sh
SCRIPT_PATH="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)/"
cd "$SCRIPT_PATH" || exit
cd ../..
rustup override set nightly
cargo clean
cargo fmt
#cargo build -vv --target=wasm32-unknown-unknown --release
cargo build --target=wasm32-unknown-unknown --release
echo "built it !"