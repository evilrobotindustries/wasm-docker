FROM rust:slim

ENV STATIC_WEB_SERVER_VERSION=2.38.1
ENV STATIC_WEB_SERVER_VERSION=${STATIC_WEB_SERVER_VERSION}

ARG TARGETARCH
ENV ARCH=$TARGETARCH

# Install tools
RUN set -eux; \
    apt-get update && \
    apt-get install -y --no-install-recommends build-essential jq libssl-dev pkg-config wget && \
    # Install wasm target
    rustup target add wasm32-unknown-unknown && \
    # Set Rust architecture
    case ${TARGETARCH} in \
    "amd64")  RUST_ARCH="x86_64"  ;; \
    "arm64")  RUST_ARCH="aarch64" ;; \
    *)        RUST_ARCH=${TARGETARCH} ;; \
    esac && \
    # Install cargo-binstall
    wget --quiet -O /tmp/cargo-binstall.tgz https://github.com/cargo-bins/cargo-binstall/releases/latest/download/cargo-binstall-${RUST_ARCH}-unknown-linux-musl.tgz && \
    tar -xvf /tmp/cargo-binstall.tgz && \
    cp cargo-binstall /usr/local/cargo/bin/ && \
    rm /tmp/cargo-binstall.tgz && \
    chmod +x /usr/local/cargo/bin/cargo-binstall && \
    # Install binaries
    cargo binstall static-web-server trunk --no-confirm && \
    # Clean up cargo registry
    rm -rf /usr/local/cargo/downloads /usr/local/cargo/registry/cache/* /usr/local/cargo/registry/index/* /usr/local/cargo/registry/src/* /usr/local/cargo/tmp && \
    # Clean up \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get remove -y --auto-remove build-essential libssl-dev pkg-config wget && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /usr/local/doc /usr/lib/llvm-11 /tmp/* /var/tmp/*

# Copy build scripts
COPY scripts/build-leptos.sh /usr/local/bin/build-leptos
RUN chmod +x /usr/local/bin/build-leptos

EXPOSE 80

# Metadata
LABEL org.opencontainers.image.vendor="ERI" \
    org.opencontainers.image.url="https://github.com/evilrobotindustries/wasm-docker" \
    org.opencontainers.image.title="Rust WebAssembly Toolchain" \
    org.opencontainers.image.description="A toolchain for Rust WebAssembly development." \
    org.opencontainers.image.version="0.4" \
    org.opencontainers.image.documentation="https://github.com/evilrobotindustries/wasm-docker"
