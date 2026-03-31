FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    VCPKG_ROOT=/opt/vcpkg

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Compilers
    gcc g++ clang clang-format clang-tidy \
    # Build systems
    cmake make ninja-build \
    # Debugger + memory analysis
    gdb valgrind \
    # Static analysis
    cppcheck \
    # Utilities
    git curl wget vim python3 python3-pip \
    # Required by vcpkg bootstrap-vcpkg.sh
    zip unzip tar \
    # Common libraries
    libboost-all-dev \
    libssl-dev \
    zlib1g-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# --- Conan 2.x (C++ package manager) ---
RUN pip3 install conan --break-system-packages && \
    conan profile detect --force

# --- vcpkg ---
# Remove this block if you do not plan to use vcpkg (saves ~3 min build time)
RUN git clone --depth=1 https://github.com/microsoft/vcpkg /opt/vcpkg && \
    /opt/vcpkg/bootstrap-vcpkg.sh -disableMetrics

ENV PATH="${VCPKG_ROOT}:${PATH}"

# --- Copy clang-format config ---
COPY .clang-format /root/.clang-format

WORKDIR /workspace

CMD ["/bin/bash"]
