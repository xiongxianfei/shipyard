# Go Development Environment

## Tools

| Tool | Purpose |
|------|---------|
| go 1.25 | Go compiler and toolchain |
| air | Hot reload — reruns on file change |
| dlv | Delve debugger |
| golangci-lint | Linter (runs many linters in one pass) |
| staticcheck | Static analysis |
| gopls | Language server |

## Quick start

```bash
make go
```

## Common workflows

### New project

```bash
mkdir /workspace/myapp && cd /workspace/myapp
go mod init github.com/yourname/myapp
go run .
```

### Hot reload with Air

```bash
cd /workspace/myapp
air          # watches *.go files and reruns on change
```

Config is at `/root/.air.toml` — copy it to your project root to customize.

### Debugging with Delve

```bash
# Start headless server (connect from IDE or another terminal)
dlv debug --headless --listen=:2345 --api-version=2 ./main.go

# Or interactive CLI debugger
dlv debug ./main.go
```

Port 2345 is exposed — connect from VS Code with the Go extension or GoLand.

### Linting

```bash
golangci-lint run ./...
staticcheck ./...
go vet ./...
```

### Testing

```bash
go test ./...
go test -race ./...          # race condition detector
go test -coverprofile=c.out ./... && go tool cover -html=c.out
```

### Common module commands

```bash
go get github.com/some/package    # add dependency
go mod tidy                       # remove unused deps
go mod download                   # pre-download all deps
go list -m all                    # list all dependencies
```

## Tips

- The Go module and build caches are stored in named Docker volumes
  (`go-mod-cache`, `go-build-cache`) — they persist between container restarts,
  making subsequent builds fast.
- Port 8080 is exposed for web applications.
