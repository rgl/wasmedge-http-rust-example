#!/bin/bash
set -euxo pipefail

if [ ! -v CI ]; then
  GITHUB_REPOSITORY='rgl/wasmedge-http-rust-example'
fi

HELLO_SOURCE_URL="https://github.com/${GITHUB_REPOSITORY:-rgl/wasmedge-http-rust-example}"
if [[ "${GITHUB_REF:-v0.0.0-dev}" =~ \/v([0-9]+(\.[0-9]+)+(-.+)?) ]]; then
  HELLO_VERSION="${BASH_REMATCH[1]}"
else
  HELLO_VERSION='0.0.0-dev'
fi
HELLO_REVISION="${GITHUB_SHA:-0000000000000000000000000000000000000000}"
HELLO_TITLE="$(basename "$GITHUB_REPOSITORY")"
HELLO_DESCRIPTION='Example WasmEdge HTTP Application written in Rust'
HELLO_LICENSE='ISC'
HELLO_AUTHOR_NAME="$(perl -ne 'print $1 if /AUTHOR_NAME: &str\s+=\s+"(.+)"/' <src/meta.rs)"
HELLO_VENDOR="$(perl -ne 'print $1 if /AUTHOR_URL: &str\s+=\s+".+\/\/(.+)"/' <src/meta.rs)"

function dependencies {
  cargo fetch --verbose
}

function build {
  sed -i -E "s,([[:space:]]SOURCE_URL: &str[[:space:]]+=[[:space:]]+).+,\1\"$HELLO_SOURCE_URL\";,g" src/meta.rs
  sed -i -E "s,([[:space:]]VERSION: &str[[:space:]]+=[[:space:]]+).+,\1\"$HELLO_VERSION\";,g" src/meta.rs
  sed -i -E "s,([[:space:]]REVISION: &str[[:space:]]+=[[:space:]]+).+,\1\"$HELLO_REVISION\";,g" src/meta.rs
  BIN_NAME="$HELLO_TITLE" \
  IMG_NAME="ghcr.io/$GITHUB_REPOSITORY" \
  IMG_TAG="$HELLO_VERSION" \
    make build
  rm -rf dist
  install -d dist
  cp target/wasm32-wasi/release/*.wasm dist/
  cp target/wasm32-wasi/release/*.img.tar dist/
}

function release {
  local image="ghcr.io/$GITHUB_REPOSITORY:$HELLO_VERSION"
  local image_created="$(date --utc '+%Y-%m-%dT%H:%M:%S.%NZ')"
  local artifact_name="$(basename "$HELLO_SOURCE_URL").tgz"

  # publish the application as a oci image artifact.
  # TODO set the oci image annotations like in disabled docker build command
  #      bellow.
	rm -rf tmp/oci-v1
	install -d tmp/oci-v1
	tar xf dist/*.img.tar -C tmp/oci-v1
  crane push tmp/oci-v1 "$image"

  # publish the application as a docker container image.
  # TODO remove the module.wasm.image/variant label as its only required by
  #      crun, which we do not use.
  if false; then
    docker build \
      --label "org.opencontainers.image.created=$image_created" \
      --label "org.opencontainers.image.source=$HELLO_SOURCE_URL" \
      --label "org.opencontainers.image.version=$HELLO_VERSION" \
      --label "org.opencontainers.image.revision=$HELLO_REVISION" \
      --label "org.opencontainers.image.title=$HELLO_TITLE" \
      --label "org.opencontainers.image.description=$HELLO_DESCRIPTION" \
      --label "org.opencontainers.image.licenses=$HELLO_LICENSE" \
      --label "org.opencontainers.image.vendor=$HELLO_VENDOR" \
      --label "org.opencontainers.image.authors=$HELLO_AUTHOR_NAME" \
      --label "module.wasm.image/variant=compat-smart" \
      -t "$image" \
      .
    docker push "$image"
  fi

  # create the release binary artifact.
  cd dist
  rm -f "$artifact_name"
  tar czf "$artifact_name" *
  echo "sha256 $(sha256sum *.tgz)" >release-notes.md
  cd ..
}

function main {
  local command="$1"; shift
  case "$command" in
    dependencies)
      dependencies "$@"
      ;;
    build)
      build "$@"
      ;;
    release)
      release "$@"
      ;;
    *)
      echo "ERROR: Unknown command $command"
      exit 1
      ;;
  esac
}

main "$@"
