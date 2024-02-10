BIN_NAME ?= wasmedge-http-rust-example
BIN_PATH := target/wasm32-wasi/release/${BIN_NAME}.wasm
IMG_PATH := target/wasm32-wasi/release/${BIN_NAME}.img.tar
IMG_NAME ?= ${BIN_NAME}
IMG_TAG  ?= 0.0.0-dev

all: build

build: ${IMG_PATH}

run: ${BIN_PATH}
	wasmedge ${BIN_PATH}

${BIN_PATH}: src/*.rs Cargo.*
	cargo build --release

${IMG_PATH}: ${BIN_PATH}
	BIN_NAME="${BIN_NAME}" \
  	IMG_NAME="${IMG_NAME}" \
  	IMG_TAG="${IMG_TAG}" \
		cargo build --release --features oci-v1-tar

clean:
	rm -rf target

.PHONY: all
.PHONY: build
.PHONY: run
.PHONY: clean
