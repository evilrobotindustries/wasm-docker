#!/bin/bash
set -e

echo "🦀 Building Leptos project with auto-detected dependencies..."

# Install project-specific tools with matching versions
echo "📦 Installing cargo-leptos..."
cargo binstall cargo-leptos --no-confirm

WASM_BINDGEN_VERSION=$(cargo metadata --format-version 1 | jq -r '.packages[] | select(.name == "wasm-bindgen") | .version')
echo "📦 Installing wasm-bindgen-cli version $WASM_BINDGEN_VERSION..."
cargo binstall wasm-bindgen-cli --version "$WASM_BINDGEN_VERSION" --no-confirm

# Build the project
echo "🔨 Building Leptos project..."
cargo leptos build --release

# Run any additional commands passed as arguments
if [ $# -gt 0 ]; then
    echo "🔧 Running post-build command: $@"
    "$@"
fi

echo "✅ Build complete!"
