# Shipyard

[![CI — CTF](https://github.com/xiongxianfei/shipyard/actions/workflows/ci-ctf.yml/badge.svg)](https://github.com/xiongxianfei/shipyard/actions/workflows/ci-ctf.yml)
[![CI — AI Coding](https://github.com/xiongxianfei/shipyard/actions/workflows/ci-ai-coding.yml/badge.svg)](https://github.com/xiongxianfei/shipyard/actions/workflows/ci-ai-coding.yml)
[![CI — C++](https://github.com/xiongxianfei/shipyard/actions/workflows/ci-cpp.yml/badge.svg)](https://github.com/xiongxianfei/shipyard/actions/workflows/ci-cpp.yml)
[![CI — Python](https://github.com/xiongxianfei/shipyard/actions/workflows/ci-python.yml/badge.svg)](https://github.com/xiongxianfei/shipyard/actions/workflows/ci-python.yml)
[![CI — Go](https://github.com/xiongxianfei/shipyard/actions/workflows/ci-go.yml/badge.svg)](https://github.com/xiongxianfei/shipyard/actions/workflows/ci-go.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Why this project

Maintaining development environments across multiple devices is painful — conflicting Python versions, missing system libraries, and inconsistent tool versions all slow you down. This project solves that by providing Docker-based, self-contained development environments you can spin up anywhere.

## What does this project do

Creates Dockerfiles and orchestration to run isolated development environments for:

- **CTF** — binary exploitation, reverse engineering, network analysis
- **AI coding** — deep learning, NLP, Jupyter notebooks
- **C++ development** — modern compilers, build systems, package managers
- **Python development** — Poetry, uv, linters, type checking
- **Go development** — hot reload, debugger, linters

## Prerequisites

- [Docker Engine](https://docs.docker.com/engine/install/) >= 24.0 with the Compose plugin (`docker compose`)
- `make` (optional, for Makefile shortcuts — available via Git for Windows, WSL, or Homebrew)
- For AI GPU support: NVIDIA driver + [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

## Quick start

```bash
# Build all images (first build takes several minutes)
make build

# Enter an environment shell
make ctf
make cpp
make python
make go

# Start Jupyter (AI coding) at http://localhost:8888
make ai
```

Without `make`:

```bash
docker compose build
docker compose run --rm ctf
docker compose run --rm cpp
docker compose run --rm python
docker compose run --rm go
docker compose up ai-coding
```

Your project files go in the `workspace/` subdirectory of each environment (e.g. `ctf/workspace/`, `go/workspace/`). These are bind-mounted into `/workspace` inside the container.

---

## Environments

### CTF (`ctf/`)

**Base image:** `ubuntu:24.04`

**Tools included:**
- `gdb` + [pwndbg](https://github.com/pwndbg/pwndbg) (auto-loaded via `.gdbinit`)
- `pwntools`, `ROPgadget`, `ropper`, `capstone`, `keystone-engine`, `unicorn`, `pycryptodome`, `z3-solver`
- `radare2`, `strace`, `ltrace`, `nmap`, `netcat`, `socat`, `patchelf`

**Notes:**
- The container runs with `--privileged` and `SYS_PTRACE` capability (required for `ptrace`-based debugging). This is configured in `docker-compose.yml`.
- `network_mode: host` in `docker-compose.yml` is Linux-only. On Windows/macOS (Docker Desktop), it is silently ignored; use the container's bridge IP or add explicit port mappings instead.

---

### AI Coding (`ai-coding/`)

**Base image:** `python:3.12-slim-bookworm` (CPU default)

**Tools included:**
- PyTorch, torchvision, torchaudio (CPU wheels)
- transformers, datasets, accelerate, huggingface-hub
- numpy, pandas, scikit-learn, matplotlib, seaborn, scipy
- Jupyter Notebook + JupyterLab (port 8888)

**Switching to GPU:**

1. Edit `ai-coding/Dockerfile` — uncomment the `nvidia/cuda` base image line and comment out the `python:3.12-slim-bookworm` line.
2. Edit `ai-coding/requirements.txt` — replace the `torch`/`torchvision`/`torchaudio` lines with:
   ```
   # Install GPU wheels manually (not from PyPI):
   # pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
   ```
3. In `docker-compose.yml`, uncomment the `deploy.resources.reservations` block under `ai-coding`.
4. Rebuild: `make build-ai`

---

### C++ Development (`cpp/`)

**Base image:** `ubuntu:24.04`

**Tools included:**
- GCC 13, G++, Clang 17, `clang-format` (config in `cpp/.clang-format`), `clang-tidy`
- CMake, Make, Ninja
- GDB, Valgrind, cppcheck
- Boost, OpenSSL, zlib
- [Conan 2.x](https://conan.io/) and [vcpkg](https://vcpkg.io/) package managers

**Note:** vcpkg bootstrap compiles from source and adds ~3 minutes to the initial build. Remove the vcpkg block from `cpp/Dockerfile` if you don't need it.

---

### Python Development (`python/`)

**Base image:** `python:3.12-slim-bookworm`

**Tools included:**
- [Poetry](https://python-poetry.org/) — dependency management and packaging
- [uv](https://github.com/astral-sh/uv) — fast pip/venv alternative
- [Ruff](https://docs.astral.sh/ruff/) — linter and formatter (replaces Flake8 + Black)
- mypy, pytest, pytest-cov, ipython, pre-commit

A starter `pyproject.toml` template is in `python/pyproject.toml.template`.

---

### Go Development (`go/`)

**Base image:** `golang:1.24-bookworm`

**Tools included:**
- [Air](https://github.com/air-verse/air) — hot reload (config in `go/.air.toml`)
- [Delve](https://github.com/go-delve/delve) (`dlv`) — debugger (port 2345)
- [golangci-lint](https://golangci-lint.run/) v1.62.0
- staticcheck, gopls

**Ports:** 8080 (app), 2345 (Delve debugger)

Go module and build caches are persisted in named Docker volumes (`go-mod-cache`, `go-build-cache`) to speed up rebuilds.

---

## Customization

- **Pin tool versions:** Edit the relevant `Dockerfile` or `requirements.txt` to lock specific versions.
- **Add packages:** Add `apt-get install` lines or `pip install` / `go install` entries to the relevant Dockerfile.
- **Rebuild a single image after changes:** `make build-ctf` / `make build-ai` / `make build-cpp` / `make build-python` / `make build-go`

## Cleanup

```bash
make stop    # stop running containers
make clean   # remove containers, images, and volumes
```
