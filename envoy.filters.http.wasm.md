## [协议] extensions.filters.http.wasm.v3.Wasm
https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/filters/http/wasm/v3/wasm.proto
```json
{
  "config": "{...}"
}
```

### config extensions.wasm.v3.PluginConfig
https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/wasm/v3/wasm.proto#envoy-v3-api-msg-extensions-wasm-v3-pluginconfig
```json
{
  "name": "...",
  "root_id": "...",
  "vm_config": "{...}",
  "": "{...}",
  "fail_open": "..."
}
```

### vm_config extensions.wasm.v3.VmConfig
https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/wasm/v3/wasm.proto#envoy-v3-api-msg-extensions-wasm-v3-vmconfig

```json
{
  "vm_id": "...",
  "runtime": "...",
  "code": "{...}",
  "configuration": "{...}",
  "allow_precompiled": "...",
  "nack_on_code_cache_miss": "..."
}
```

### code config.core.v3.AsyncDataSource
https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/core/v3/base.proto#envoy-v3-api-msg-config-core-v3-asyncdatasource

```json
{
  "local": "{...}",
  "remote": "{...}"
}
```

#### local config.core.v3.DataSource
https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/core/v3/base.proto#envoy-v3-api-msg-config-core-v3-datasource
```json
{
  "filename": "...",
  "inline_bytes": "...",
  "inline_string": "..."
}
```
- filename  (string) Local filesystem data source.
- inline_bytes (bytes) Bytes inlined in the configuration.
- inline_string (string) String inlined in the configuration.

#### remote config.core.v3.RemoteDataSource
https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/core/v3/base.proto#envoy-v3-api-msg-config-core-v3-remotedatasource
```json
{
  "http_uri": "{...}",
  "sha256": "...",
  "retry_policy": "{...}"
}
```
- http_uri (config.core.v3.HttpUri, REQUIRED) The HTTP URI to fetch the remote data.
- sha256 (string, REQUIRED) SHA256 string for verifying data.
- retry_policy (config.core.v3.RetryPolicy) Retry policy for fetching remote data.

#### http_uri config.core.v3.HttpUri
https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/core/v3/http_uri.proto#envoy-v3-api-msg-config-core-v3-httpuri
```json
{
"uri": "...",
"cluster": "...",
"timeout": "{...}"
}
```
- uri (string, REQUIRED) The HTTP server URI. It should be a full FQDN with protocol, host and path.
- cluster (string, REQUIRED) A cluster is created in the Envoy “cluster_manager” config section. This field specifies the cluster name.
- timeout ([Duration](https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#duration), REQUIRED) 
  Sets the maximum duration in milliseconds that a response can take to arrive upon request.

#### retry_policy config.core.v3.RetryPolicy
https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/core/v3/base.proto#envoy-v3-api-msg-config-core-v3-retrypolicy
```json
{
"retry_back_off": "{...}",
"num_retries": "{...}"
}
```
- retry_back_off (config.core.v3.BackoffStrategy) Specifies parameters that control retry backoff strategy. 
  This parameter is optional, in which case the default base interval is 1000 milliseconds. 
  The default maximum interval is 10 times the base interval.
- num_retries (UInt32Value) Specifies the allowed number of retries. This parameter is optional and defaults to 1.

#### retry_back_off config.core.v3.BackoffStrategy
https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/core/v3/backoff.proto#envoy-v3-api-msg-config-core-v3-backoffstrategy
```json
{
"base_interval": "{...}",
"max_interval": "{...}"
}
```
- base_interval (Duration, REQUIRED) The base interval to be used for the next back off computation. 
  It should be greater than zero and less than or equal to max_interval.
- max_interval (Duration) Specifies the maximum interval between retries. 
  This parameter is optional, but must be greater than or equal to the base_interval if set. 
  The default is 10 times the base_interval.