# Getting Started

## Prerequisites

- [Docker Engine](https://docs.docker.com/engine/install/) >= 24.0 with the Compose plugin
- `make` (optional) — available via Git for Windows, WSL, or Homebrew on macOS
- Git

## Option A — Pull pre-built images (fastest)

Images are published to GitHub Container Registry on every merge to `main`.
No build step required:

```bash
docker pull ghcr.io/xiongxianfei/dev-ctf:latest
docker pull ghcr.io/xiongxianfei/dev-binary-analysis:latest
docker pull ghcr.io/xiongxianfei/dev-ai:latest
docker pull ghcr.io/xiongxianfei/dev-cpp:latest
docker pull ghcr.io/xiongxianfei/dev-python:latest
docker pull ghcr.io/xiongxianfei/dev-go:latest
docker pull ghcr.io/xiongxianfei/dev-java:latest
docker pull ghcr.io/xiongxianfei/dev-rust:latest
```

Then run directly:

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  ghcr.io/xiongxianfei/dev-python:latest
```

## Option B — Build locally

```bash
git clone https://github.com/xiongxianfei/shipyard.git
cd shipyard

make build          # build all images (~30-40 min first time)
# or build one at a time:
make build-python
make build-go
```

## Entering an environment

```bash
make ctf
make binary-analysis
make cpp
make python
make go
make java
make rust
make ai             # starts Jupyter at http://localhost:8888
```

Without `make`:

```bash
docker compose run --rm python
docker compose run --rm go
docker compose up ai-coding
```

## Working with files

Each environment has a `workspace/` directory on your host that is
bind-mounted to `/workspace` inside the container:

```
shipyard/
├── ctf/workspace/           ← put your files here on the host
├── binary-analysis/workspace/
├── python/workspace/
└── ...
```

Files written inside the container at `/workspace` persist after the
container exits. Everything else is ephemeral.

## Keeping images up to date

```bash
# Pull latest pre-built images
docker pull ghcr.io/xiongxianfei/dev-python:latest

# Or rebuild locally after a git pull
git pull
make build
```

## Cleaning up

```bash
make stop    # stop all running containers
make clean   # remove containers, images, and named volumes
```
