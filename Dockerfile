FROM rust:slim

ENV STATIC_WEB_SERVER_VERSION=2.3.0
ENV STATIC_WEB_SERVER_VERSION=${STATIC_WEB_SERVER_VERSION}

# Install tools
RUN apt-get update; \
    apt-get install -y --no-install-recommends libssl-dev pkg-config wget; \
    # Install static-web-server
	wget --quiet -O /tmp/static-web-server.tar.gz "https://github.com/joseluisq/static-web-server/releases/download/v$STATIC_WEB_SERVER_VERSION/static-web-server-v$STATIC_WEB_SERVER_VERSION-x86_64-unknown-linux-gnu.tar.gz"; \
    tar xzvf /tmp/static-web-server.tar.gz; \
    cp static-web-server-v${STATIC_WEB_SERVER_VERSION}-x86_64-unknown-linux-gnu/static-web-server /usr/local/bin/; \
	rm -rf /tmp/static-web-server.tar.gz static-web-server-v${STATIC_WEB_SERVER_VERSION}-x86_64-unknown-linux-gnu; \
	chmod +x /usr/local/bin/static-web-server; \
    # Install wasm-bindgen
    cargo install wasm-bindgen-cli; \
    rustup target add wasm32-unknown-unknown; \
    # Clean up
    apt-get remove -y --auto-remove libssl-dev pkg-config wget ; \
    rm -rf /var/lib/apt/lists/*;
EXPOSE 80