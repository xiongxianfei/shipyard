# Security Policy

## Supported Versions

This project provides Docker images for development use. Security fixes are applied to the
current `main` branch only.

| Branch | Supported |
| ------ | --------- |
| main   | Yes       |

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

If you discover a security vulnerability (e.g., a Dockerfile that installs a package with a
known CVE, or a misconfiguration that could expose a host system), please report it via
[GitHub's private vulnerability reporting](https://github.com/xiongxianfei/shipyard/security/advisories/new).

You can expect:
- Acknowledgement within **3 business days**
- A fix or mitigation plan within **14 days** for critical issues

## Security Considerations for Users

These images are intended for **local development only**. Before using them:

- The `ctf` container runs with `--privileged` and `SYS_PTRACE` — do not expose it to untrusted
  networks.
- Do not store secrets or credentials inside containers or in the `workspace/` directories if
  they are shared or synced.
- Rebuild images periodically (`make build`) to pull updated base image layers with upstream
  security patches.
- For the AI coding image, GPU support requires the NVIDIA Container Toolkit — follow its
  official security hardening guidance if running in a shared environment.
