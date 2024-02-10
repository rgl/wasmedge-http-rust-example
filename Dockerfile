# syntax=docker/dockerfile:1.6
FROM scratch
COPY ./dist/wasmedge-http-rust-example.wasm .
ENTRYPOINT ["/wasmedge-http-rust-example.wasm"]
