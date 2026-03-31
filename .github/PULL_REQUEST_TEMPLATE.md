## Summary

<!-- What does this PR change and why? -->

## Type of change

- [ ] Bug fix (a Dockerfile step that was broken)
- [ ] New environment
- [ ] Tool version bump
- [ ] Documentation update
- [ ] CI / workflow change

## Checklist

- [ ] `docker build` completes without error locally (`make build-<env>`)
- [ ] Smoke tests pass locally (`docker run --rm dev-<env>:latest <tool> --version`)
- [ ] README updated if tools were added or removed
- [ ] No secrets, credentials, or `*/workspace/` files included
- [ ] If a new environment was added: workflow file added in `.github/workflows/`
