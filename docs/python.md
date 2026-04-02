# Python Development Environment

## Tools

| Tool | Purpose |
|------|---------|
| Python 3.12 | Runtime |
| Poetry | Dependency management and packaging |
| uv | Fast pip/venv alternative |
| Ruff | Linter and formatter (replaces Flake8 + Black) |
| mypy | Static type checker |
| pytest + pytest-cov | Testing and coverage |
| ipython | Enhanced REPL |
| pre-commit | Git hook manager |

## Quick start

```bash
make python
```

## Common workflows

### Start a new project with Poetry

```bash
cd /workspace
poetry new my-project
cd my-project
poetry add requests
poetry run python main.py
```

Copy `python/pyproject.toml.template` as a starting point — it has ruff and mypy pre-configured.

### Start a new project with uv (faster)

```bash
cd /workspace
uv init my-project
cd my-project
uv add requests
uv run python main.py
```

### Linting and formatting

```bash
ruff check .           # lint
ruff check --fix .     # lint and auto-fix
ruff format .          # format (replaces Black)
mypy .                 # type check
```

### Testing

```bash
pytest                             # run all tests
pytest -v                          # verbose
pytest --cov=. --cov-report=html   # with coverage report
```

### Virtual environments

```bash
# uv (fastest)
uv venv && source .venv/bin/activate
uv pip install -r requirements.txt

# poetry (project-aware)
poetry install
poetry shell
```

## Tips

- `POETRY_VIRTUALENVS_CREATE=false` is set — Poetry installs into the system
  Python rather than creating a venv. This keeps the container simple.
  Override it if you need isolated envs: `export POETRY_VIRTUALENVS_CREATE=true`.
