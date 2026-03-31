FROM golang:1.24-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    CGO_ENABLED=1 \
    GOPATH=/go \
    PATH="/go/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget vim make \
    gcc g++ \
    && rm -rf /var/lib/apt/lists/*

# --- Air (hot reload) ---
RUN go install github.com/air-verse/air@latest

# --- Delve (debugger) ---
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# --- golangci-lint ---
RUN curl -sSfL \
    https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh \
    | sh -s -- -b /usr/local/bin v1.62.0

# --- staticcheck ---
RUN go install honnef.co/go/tools/cmd/staticcheck@latest

# --- gopls (language server) ---
RUN go install golang.org/x/tools/gopls@latest

# --- Copy Air config ---
COPY .air.toml /root/.air.toml

WORKDIR /workspace

EXPOSE 8080 2345

CMD ["/bin/bash"]
