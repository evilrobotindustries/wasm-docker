# wasm-docker
A Dockerised toolchain for Rust WebAssembly development/deployment, based on the [rust:slim](https://hub.docker.com/_/rust) image.

The image also includes the following tools:

## [wasm-bindgen](https://github.com/rustwasm/wasm-bindgen)
"Facilitating high-level interactions between Wasm modules and JavaScript", used to generate the final wasm image along with .js bootstrap code.

    # Development/debug
    cargo build --target wasm32-unknown-unknown && wasm-bindgen --debug --no-typescript --out-dir www/pkg --target web ./target/wasm32-unknown-unknown/debug/*.wasm
    # Release/deployment
    cargo build --release --target wasm32-unknown-unknown && wasm-bindgen --browser --no-typescript --out-dir www/pkg --target web ./target/wasm32-unknown-unknown/release/*.wasm

## [static-web-server](https://github.com/joseluisq/static-web-server)
A Rust-based static web server, for hosting static content over HTTPS. The following example starts the server using the www directory as the root and turns on tracing for debugging: 

    static-web-server --root ./www -g trace

A certificate can then be generated on the development host using [mkcert](https://github.com/FiloSottile/mkcert) and then supplied via the following example command when running the container, with the certificates on the host made available to the container via bind mounts:

    static-web-server --root ./www -g trace --http2 true --http2-tls-cert /localhost.pem --http2-tls-key /localhost-key.pem

## [trunk](https://github.com/thedodd/trunk)
"Trunk is a WASM web application bundler for Rust", included for producing trunk builds when using trunk during development.