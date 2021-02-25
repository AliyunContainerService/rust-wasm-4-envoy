# rust-wasm-4-envoy

```bash
rustup toolchain install nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
```

### PropagandaFilter

#### dev
```bash
cargo new --lib propaganda-filter
```

```bash
vi propaganda-filter/Cargo.toml

[lib]
crate-type = ["cdylib"]

[dependencies]
proxy-wasm = "0.1.3"
```

```bash
cd propaganda-filter
sh build.sh
```

#### test

```bash
docker-compose up --build
```

```bash
curl  -H "token":"323232" 0.0.0.0:18000
```



## Reference

### Proxy WASM SDK
- <https://github.com/proxy-wasm/proxy-wasm-rust-sdk>
- <https://github.com/envoyproxy/envoy-wasm>