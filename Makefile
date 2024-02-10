BIN_PATH = target/wasm32-wasi/release/wasmedge-http-rust-example.wasm
IMG_PATH = target/wasm32-wasi/release/wasmedge-http-rust-example.img.tar

all: build

build: ${IMG_PATH}

run: build
	wasmedge ${BIN_PATH}

${BIN_PATH}: src/*.rs Cargo.*
	cargo build --release

${IMG_PATH}: ${BIN_PATH}
	cargo build --release --features oci-v1-tar

clean:
	rm -rf target

.PHONY: all
.PHONY: build
.PHONY: run
.PHONY: clean
