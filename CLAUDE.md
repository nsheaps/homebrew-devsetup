# Project Rules for homebrew-devsetup

## Linting Architecture

This project uses a **unified linting approach** via mise tasks, NOT separate GitHub Actions per linter.

### Key Principles

1. **All linters belong in the `format` and `lint` mise tasks** - NOT in separate workflow jobs or actions
2. **The `format` task applies auto-fixes** (e.g., `prettier --write`, `rubocop -A`)
3. **The `lint` task only checks** (e.g., `prettier --check`, `rubocop`)
4. **The CI workflow runs `mise run format`** which handles ALL linting and auto-commits fixes
5. **Security linters are the exception** - they use the action-per-linter pattern because they have different concerns and don't auto-fix

### Linters in format/lint tasks

- prettier (formatting)
- editorconfig-checker (editor config compliance)
- v8r (config file validation)
- rubocop (Ruby linting)
- cspell (spell checking)

### Security linters (separate actions)

- secretlint, syft, trivy, trufflehog, checkov, kics, grype, gitleaks

### Adding a new linter

1. Add the tool to `mise.toml`
2. Add the linter command to `.mise/tasks/format` (with auto-fix if available)
3. Add the linter command to `.mise/tasks/lint` (check-only mode)
4. Do NOT create a separate GitHub Action or workflow job for it

### Why this architecture?

- The `format` workflow auto-commits fixes, so all fixable linters should run together
- Keeps CI simple: one job for formatting/linting, one for security
- Avoids proliferation of tiny workflow jobs
