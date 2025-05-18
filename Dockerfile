FROM rust:1.86-slim

ENV WASM_BINDGEN_CLI_VERSION=0.2.100
ENV WASM_BINDGEN_CLI_VERSION=${WASM_BINDGEN_CLI_VERSION}

ENV STATIC_WEB_SERVER_VERSION=2.36.1
ENV STATIC_WEB_SERVER_VERSION=${STATIC_WEB_SERVER_VERSION}

ARG TARGETARCH
ENV ARCH=$TARGETARCH

# Install tools
RUN set -eux; \
    apt-get update && \
    apt-get install -y --no-install-recommends build-essential libssl-dev pkg-config wget && \
    # Install wasm-bindgen
    cargo install wasm-bindgen-cli --version ${WASM_BINDGEN_CLI_VERSION} && \
    rustup target add wasm32-unknown-unknown && \
    # Install trunk
    cargo install trunk && \
    # Install cargo-leptos
    cargo install cargo-leptos --locked && \
    # Clean up cargo registry
    rm -rf /usr/local/cargo/downloads /usr/local/cargo/registry/cache/* /usr/local/cargo/registry/index/* /usr/local/cargo/registry/src/* /usr/local/cargo/tmp && \
    # Install static-web-server \
    case ${TARGETARCH} in \
        "amd64")  RUST_ARCH="x86_64"  ;; \
        "arm64")  RUST_ARCH="aarch64" ;; \
        *)        RUST_ARCH=${TARGETARCH} ;; \
    esac && \
	wget --quiet -O /tmp/static-web-server.tar.gz "https://github.com/joseluisq/static-web-server/releases/download/v$STATIC_WEB_SERVER_VERSION/static-web-server-v$STATIC_WEB_SERVER_VERSION-$RUST_ARCH-unknown-linux-gnu.tar.gz" && \
    tar xzvf /tmp/static-web-server.tar.gz && \
    cp static-web-server-v${STATIC_WEB_SERVER_VERSION}-${RUST_ARCH}-unknown-linux-gnu/static-web-server /usr/local/bin/ && \
	rm -rf /tmp/static-web-server.tar.gz static-web-server-v${STATIC_WEB_SERVER_VERSION}-${RUST_ARCH}-unknown-linux-gnu && \
	chmod +x /usr/local/bin/static-web-server && \
    # Clean up \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get remove -y --auto-remove build-essential libssl-dev pkg-config wget && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /usr/local/doc /usr/lib/llvm-11 /tmp/* /var/tmp/*

EXPOSE 80

# Metadata
LABEL org.opencontainers.image.vendor="Evil Robot Industries" \
    org.opencontainers.image.url="https://github.com/evilrobotindustries/wasm-docker" \
    org.opencontainers.image.title="Rust WebAssembly Toolchain" \
    org.opencontainers.image.description="A toolchain for Rust WebAssembly development." \
    org.opencontainers.image.version="0.2" \
    org.opencontainers.image.documentation="https://github.com/evilrobotindustries/wasm-docker"
