FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

# --- System packages ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Python runtime
    python3 python3-pip python3-dev python3-venv \
    # Core utilities
    git curl wget vim tmux \
    # Debugger
    gdb gdbserver \
    # Binutils: objdump, readelf, nm, strings, strip, size, ar, objcopy
    binutils \
    # File identification and hex inspection
    file xxd hexedit \
    # System call / library tracing
    strace ltrace \
    # Memory analysis
    valgrind \
    # Assemblers
    nasm yasm \
    # Cross-architecture emulation (run foreign ELFs natively)
    qemu-user-static \
    # radare2
    radare2 \
    # Build tools (needed for some pip packages with native extensions)
    gcc g++ make \
    libssl-dev libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# --- Python binary analysis libraries (venv for PEP 668 compliance) ---
RUN python3 -m venv /opt/ba-venv
ENV PATH="/opt/ba-venv/bin:$PATH"

RUN pip install --upgrade pip && \
    # Disassembly / assembly / emulation core
    pip install \
        capstone \
        unicorn \
        keystone-engine \
    && \
    # Binary format parsers
    pip install \
        pyelftools \
        pefile \
        lief \
    && \
    # Binary analysis platform (symbolic execution, CFG, ...)
    # Installed separately to isolate its large dependency tree
    pip install angr && \
    # Firmware / embedded binary analysis
    pip install binwalk && \
    # Pattern matching (malware signatures, file identification)
    pip install yara-python && \
    # ROP chain finding
    pip install ROPgadget ropper && \
    # Dynamic instrumentation toolkit
    pip install frida-tools && \
    # Useful scripting utilities
    pip install pwntools r2pipe

# --- pwndbg (pin to release tag — update periodically) ---
RUN git clone --depth=1 --branch 2026.02.18 \
        https://github.com/pwndbg/pwndbg /opt/pwndbg && \
    cd /opt/pwndbg && ./setup.sh

COPY .gdbinit /root/.gdbinit

WORKDIR /workspace

CMD ["/bin/bash"]
