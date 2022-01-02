FROM rust:slim

# Install wasm-pack
RUN apt-get update; \
    apt-get install -y --no-install-recommends wget; \
    wget https://rustwasm.github.io/wasm-pack/installer/init.sh -O - | sh; \
    apt-get remove -y --auto-remove wget ; \
    rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["wasm-pack"]