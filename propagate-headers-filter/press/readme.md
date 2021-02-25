
### config
```bash
vi common/config
```
- `NUM`
- `QPS`
- `Duration`

### run
```bash
sh sidecar/press.sh
sh wasm-sidecar/press.sh
sh lua-sidecar/press.sh
```

### report
```bash
cat _result/sidecar.result
cat _result/wasm-sidecar.result
cat _result/lua-sidecar.result
```