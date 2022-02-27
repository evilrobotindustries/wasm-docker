FROM rust:slim

ENV WASM_BINDGEN_CLI_VERSION=0.2.79
ENV WASM_BINDGEN_CLI_VERSION=${WASM_BINDGEN_CLI_VERSION}

ENV STATIC_WEB_SERVER_VERSION=2.5.0
ENV STATIC_WEB_SERVER_VERSION=${STATIC_WEB_SERVER_VERSION}

# Install tools
RUN apt-get update; \
    apt-get install -y --no-install-recommends libssl-dev pkg-config wget; \
    # Install wasm-bindgen
    cargo install wasm-bindgen-cli --version ${WASM_BINDGEN_CLI_VERSION}; \
    rustup target add wasm32-unknown-unknown; \
    rm /usr/local/cargo/registry/cache/* -rf; \
    rm /usr/local/cargo/registry/index/* -rf; \
    rm /usr/local/cargo/registry/src/* -rf; \
    # Install static-web-server
	wget --quiet -O /tmp/static-web-server.tar.gz "https://github.com/joseluisq/static-web-server/releases/download/v$STATIC_WEB_SERVER_VERSION/static-web-server-v$STATIC_WEB_SERVER_VERSION-x86_64-unknown-linux-gnu.tar.gz"; \
    tar xzvf /tmp/static-web-server.tar.gz; \
    cp static-web-server-v${STATIC_WEB_SERVER_VERSION}-x86_64-unknown-linux-gnu/static-web-server /usr/local/bin/; \
	rm -rf /tmp/static-web-server.tar.gz static-web-server-v${STATIC_WEB_SERVER_VERSION}-x86_64-unknown-linux-gnu; \
	chmod +x /usr/local/bin/static-web-server; \
    # Clean up
    apt-get remove -y --auto-remove libssl-dev pkg-config wget ; \
    rm -rf /var/lib/apt/lists/*;
EXPOSE 80

# Metadata
LABEL org.opencontainers.image.vendor="Evil Robot Industries" \
    org.opencontainers.image.url="https://github.com/evilrobotindustries/wasm-docker" \
    org.opencontainers.image.title="Rust WebAssembly Toolchain" \
    org.opencontainers.image.description="A toolchain for Rust WebAssembly development." \
    org.opencontainers.image.version="0.1" \
    org.opencontainers.image.documentation="https://github.com/evilrobotindustries/wasm-docker"
