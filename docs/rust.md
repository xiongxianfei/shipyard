# Rust Development Environment

## Tools

| Tool | Purpose |
|------|---------|
| rustc | Rust compiler (stable channel) |
| cargo | Package manager and build tool |
| clippy | Linter — catches common mistakes |
| rustfmt | Code formatter |
| rust-analyzer | Language server (for IDE integration) |
| cargo-watch | Re-run commands on file change (hot reload) |
| cargo-edit | `cargo add` / `cargo rm` / `cargo upgrade` |
| cargo-audit | Audit dependencies for known CVEs |
| cargo-nextest | Faster test runner with better output |

## Quick start

```bash
make rust
# or: docker compose run --rm rust
```

## Common workflows

### Create a new project

```bash
cargo new my-app          # binary
cargo new my-lib --lib    # library
cd my-app
cargo run
```

### Build and test

```bash
cargo build               # debug build
cargo build --release     # optimized build
cargo test                # run tests
cargo nextest run         # run tests with nextest (better output)
cargo clippy              # lint
cargo fmt                 # format code
```

### Watch mode (auto-recompile on save)

```bash
cargo watch -x run        # rerun on change
cargo watch -x test       # retest on change
cargo watch -x "clippy -- -D warnings"
```

### Dependency management

```bash
cargo add serde --features derive    # add a dependency
cargo add tokio --features full      # async runtime
cargo rm serde                       # remove a dependency
cargo upgrade                        # upgrade all deps to latest
cargo audit                          # check for CVEs
```

### Common dependencies

```toml
# Cargo.toml

[dependencies]
# Serialization
serde = { version = "1", features = ["derive"] }
serde_json = "1"

# Async runtime
tokio = { version = "1", features = ["full"] }

# HTTP client
reqwest = { version = "0.12", features = ["json"] }

# CLI argument parsing
clap = { version = "4", features = ["derive"] }

# Error handling
anyhow = "1"
thiserror = "1"

# Logging
tracing = "0.1"
tracing-subscriber = "0.3"
```

### Cross-compilation

The container includes `qemu-user-static` via the base image. To cross-compile:

```bash
# Add a target
rustup target add aarch64-unknown-linux-gnu

# Install the cross-linker
apt-get install -y gcc-aarch64-linux-gnu

# Build
cargo build --target aarch64-unknown-linux-gnu
```

## Tips

- Cargo's registry cache is inside the container. Mount `~/.cargo/registry` as a
  volume to avoid re-downloading crates on each session:
  ```bash
  docker run -it --rm \
    -v $(pwd):/workspace \
    -v $HOME/.cargo/registry:/usr/local/cargo/registry \
    ghcr.io/xiongxianfei/dev-rust:latest
  ```
- The `target/` directory can grow large. Add it to `.gitignore` and consider
  mounting it as a named volume if build times feel slow across sessions.
