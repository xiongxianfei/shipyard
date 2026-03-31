# Contributing

Thank you for your interest in contributing!

## Prerequisites

- [Docker Engine](https://docs.docker.com/engine/install/) >= 24.0 with the Compose plugin
- `make` (optional, for convenience targets)
- Git

## Getting started

```bash
git clone <repo-url>
cd <repo>
make build        # build all images (~25-35 min first time)
make python       # quick sanity check
```

## Project structure

Each environment lives in its own directory with a `Dockerfile` and supporting config files.
`docker-compose.yml` wires them together and `Makefile` provides shorthand targets.
A GitHub Actions workflow in `.github/workflows/` validates every image on push.

## Adding a new environment

1. Create a directory `<name>/` with a `Dockerfile` (and any supporting files).
2. Add a service entry to `docker-compose.yml`.
3. Add `build-<name>` and `<name>` targets to the `Makefile`.
4. Create `.github/workflows/ci-<name>.yml` following the pattern of an existing workflow.
5. Update `README.md` — prerequisites, quick start table, and a dedicated environment section.

## Modifying an existing environment

- Test locally before pushing: `make build-<env>` then `docker run --rm dev-<env>:latest <tool> --version`.
- Keep `RUN` steps grouped and clean up package manager caches in the **same layer**:
  ```dockerfile
  RUN apt-get update && apt-get install -y --no-install-recommends \
      package-a package-b \
      && rm -rf /var/lib/apt/lists/*
  ```
- Add a comment above any non-obvious `RUN` step.
- If you add or remove a tool, update the environment section in `README.md` and the smoke test
  commands in the corresponding `.github/workflows/ci-<env>.yml`.

## Pull request checklist

- [ ] `docker build` completes without error locally (`make build-<env>`)
- [ ] Smoke tests pass locally (`docker run --rm dev-<env>:latest <tool> --version`)
- [ ] `README.md` updated if tools were added or removed
- [ ] No secrets, credentials, or `*/workspace/` files committed

## Reporting issues

Please include:
- Which environment is affected (ctf / ai-coding / cpp / python / go)
- Host OS and Docker version (`docker version`)
- Full error output from `docker build` or `docker run`

## Code style

- Group related packages in a single `RUN apt-get install` call.
- Clean apt lists (`rm -rf /var/lib/apt/lists/*`) in the same `RUN` layer.
- One blank line between logical sections in a Dockerfile.
- Prefer pinned versions for tools installed via `go install` or `pip install` in CI-critical paths.
