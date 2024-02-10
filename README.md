# About

[![Build status](https://github.com/rgl/wasmedge-http-rust-example/workflows/build/badge.svg)](https://github.com/rgl/wasmedge-http-rust-example/actions?query=workflow%3Abuild)

Example WasmEdge HTTP Application written in Rust.

# Usage

Install [Rust](https://github.com/rust-lang/rust), the [wasm32-wasi target](https://bytecodealliance.github.io/cargo-wasi/steps.html) and [WasmEdge](https://github.com/WasmEdge/WasmEdge).

Start the application:

```bash
make run
```

Access the HTTP endpoint:

```bash
xdg-open http://localhost:8080
```

## Kubernetes Usage

TODO

# References

* [Develop WASM Apps in Rust, HTTP Services, Server](https://wasmedge.org/docs/develop/rust/http_service/server/#the-warp-api)
* [Container image for a WASI WebAssembly app](https://github.com/second-state/wasmedge-containers-examples/blob/main/simple_wasi_app.md)
* [wasi-demo-app](https://github.com/containerd/runwasi/tree/containerd-shim-wasmedge/v0.3.0/crates/wasi-demo-app)
* [Done icon](https://icons8.com/icon/uw-X2j32n7Xp/done)
