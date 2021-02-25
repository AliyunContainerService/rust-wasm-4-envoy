use log::{info, warn};
use proxy_wasm::traits::*;
use proxy_wasm::types::*;
use serde_json::Value;

#[no_mangle]
pub fn _start() {
    proxy_wasm::set_log_level(LogLevel::Info);
    proxy_wasm::set_root_context(|_| -> Box<dyn RootContext> {
        Box::new(PropagandaHeaderRoot {
            config: FilterConfig {
                head_tag_name: "".to_string(),
                head_tag_value: "".to_string(),
            },
        })
    });
}

struct PropagandaHeaderFilter {
    context_id: u32,
    config: FilterConfig,
}

struct PropagandaHeaderRoot {
    config: FilterConfig,
}

struct FilterConfig {
    head_tag_name: String,
    head_tag_value: String,
}

impl HttpContext for PropagandaHeaderFilter {
    fn on_http_request_headers(&mut self, _: usize) -> Action {
        let head_tag_key = self.config.head_tag_name.as_str();
        info!("::::head_tag_key={}", head_tag_key);
        if !head_tag_key.is_empty() {
            self.set_http_request_header(head_tag_key, Some(self.config.head_tag_value.as_str()));
            //https://github.com/istio/istio/issues/30545#issuecomment-783518257
            //https://github.com/proxy-wasm/spec/issues/16 &
            //https://www.elvinefendi.com/2020/12/09/dynamic-routing-envoy-wasm.html
            self.clear_http_route_cache();
        }
        for (name, value) in &self.get_http_request_headers() {
            info!("::::H[{}] -> {}: {}", self.context_id, name, value);
        }
        Action::Continue
    }
}

impl RootContext for PropagandaHeaderRoot {
    fn on_configure(&mut self, _plugin_configuration_size: usize) -> bool {
        if self.config.head_tag_name == "" {
            match self.get_configuration() {
                Some(config_bytes) => {
                    let cfg: Value = serde_json::from_slice(config_bytes.as_slice()).unwrap();
                    self.config.head_tag_name = cfg
                        .get("head_tag_name")
                        .unwrap()
                        .as_str()
                        .unwrap()
                        .to_string();
                    self.config.head_tag_value = cfg
                        .get("head_tag_value")
                        .unwrap()
                        .as_str()
                        .unwrap()
                        .to_string();
                }
                None => {
                    warn!("NO CONFIG");
                }
            }
        }
        true
    }
    fn create_http_context(&self, context_id: u32) -> Option<Box<dyn HttpContext>> {
        info!(
            "::::create_http_context head_tag_name={},head_tag_value={}",
            self.config.head_tag_name, self.config.head_tag_value
        );
        Some(Box::new(PropagandaHeaderFilter {
            context_id,
            config: FilterConfig {
                head_tag_name: self.config.head_tag_name.clone(),
                head_tag_value: self.config.head_tag_value.clone(),
            },
        }))
    }
    fn get_type(&self) -> Option<ContextType> {
        Some(ContextType::HttpContext)
    }
}

impl Context for PropagandaHeaderFilter {}

impl Context for PropagandaHeaderRoot {}
