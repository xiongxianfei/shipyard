FROM rust:1-bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget vim make \
    gcc g++ pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# --- Rust components (via rustup) ---
RUN rustup component add clippy rustfmt rust-analyzer

# --- cargo-binstall: installs pre-compiled binaries instead of compiling from source ---
RUN curl -L --proto '=https' --tlsv1.2 -sSf \
    https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
    | bash

# --- Cargo tools (downloaded as pre-built binaries via binstall) ---
RUN cargo binstall -y \
    cargo-watch \
    cargo-edit \
    cargo-audit \
    cargo-nextest

WORKDIR /workspace

CMD ["/bin/bash"]
