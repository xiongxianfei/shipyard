FROM python:3.12-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_HOME=/opt/poetry \
    POETRY_VIRTUALENVS_CREATE=false

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget vim make \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# --- Poetry ---
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /opt/poetry/bin/poetry /usr/local/bin/poetry

# --- uv (fast pip/venv alternative) ---
RUN pip install uv

# --- Dev tools ---
RUN pip install \
    ruff \
    mypy \
    pytest \
    pytest-cov \
    ipython \
    pre-commit

WORKDIR /workspace

CMD ["/bin/bash"]
