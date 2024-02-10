#!/bin/bash
set -euxo pipefail

# see https://github.com/WasmEdge/WasmEdge/releases
WASMEDGE_VERSION="${WASMEDGE_VERSION:-0.13.5}"

# bail when already installed.
if [ -x /usr/local/bin/wasmedge ]; then
    # e.g. wasmedge version 0.13.5
    actual_version="$(/usr/local/bin/wasmedge --version | perl -ne '/([^ ]+)$/ && print $1')"
    if [ "$actual_version" == "$WASMEDGE_VERSION" ]; then
        echo 'ANSIBLE CHANGED NO'
        exit 0
    fi
fi

# download and install.
wasmedge_url="https://github.com/WasmEdge/WasmEdge/releases/download/${WASMEDGE_VERSION}/WasmEdge-${WASMEDGE_VERSION}-ubuntu20.04_x86_64.tar.gz"
rm -rf /opt/wasmedge
install -d /opt/wasmedge
wget -qO- "$wasmedge_url" | tar xzf - -C /opt/wasmedge --strip-components 1
ln -fs /opt/wasmedge/bin/wasmedge /usr/local/bin/
