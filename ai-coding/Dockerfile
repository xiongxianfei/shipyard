# ---- CPU variant (default) ----
FROM python:3.12-slim-bookworm

# ---- GPU variant: uncomment below and comment out the CPU line above ----
# FROM nvidia/cuda:12.8.1-cudnn-runtime-ubuntu22.04
# RUN apt-get update && apt-get install -y python3.12 python3-pip \
#     && ln -sf python3 /usr/bin/python && ln -sf pip3 /usr/bin/pip \
#     && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget vim build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# --- Copy pinned requirements ---
COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# --- Jupyter config: allow connections from outside the container ---
RUN jupyter notebook --generate-config && \
    echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py

EXPOSE 8888

CMD ["jupyter", "notebook", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
