FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

# --- System packages ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Core utilities
    python3 python3-pip python3-dev python3-venv \
    git curl wget vim tmux \
    # Binary analysis
    gdb gdbserver \
    binutils file \
    strace ltrace \
    # Network tools
    nmap netcat-openbsd \
    # Crypto / encoding
    openssl \
    # Build tools (needed for some pip packages)
    gcc g++ make \
    # Misc CTF staples
    socat patchelf \
    libssl-dev libffi-dev \
    # radare2
    radare2 \
    # Misc useful utilities
    xxd strings less \
    && rm -rf /var/lib/apt/lists/*

# --- Python CTF libraries (venv to satisfy Ubuntu 24.04 PEP 668) ---
RUN python3 -m venv /opt/ctf-venv
ENV PATH="/opt/ctf-venv/bin:$PATH"
RUN pip install --upgrade pip && \
    pip install \
        pwntools \
        ROPgadget \
        ropper \
        keystone-engine \
        unicorn \
        capstone \
        pycryptodome \
        z3-solver

# --- pwndbg ---
RUN git clone --depth=1 --branch stable \
        https://github.com/pwndbg/pwndbg /opt/pwndbg && \
    cd /opt/pwndbg && ./setup.sh

# --- .gdbinit to auto-load pwndbg ---
COPY .gdbinit /root/.gdbinit

WORKDIR /workspace

CMD ["/bin/bash"]
