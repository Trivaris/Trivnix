# Copilot Instructions for Trivnix AI Coding Agents

## Project Overview
- **Trivnix** provides reusable NixOS and Home Manager modules, overlays, and utilities. It is designed to be used alongside `trivnixLib`, `trivnixConfigs`, and `trivnixPrivate`.
- The repo is flake-based. All canonical flake inputs are in `flake.nix`, with logic under `flake/`.
- Modules are split between `host/` (system-level) and `home/` (user-level), with further organization into `common/` and `modules/`.
- Secrets are managed via `sops-nix` and must not be decrypted or rewritten by agents.

## Key Workflows
- **Validation:** Use `nix flake check` (see `docs/usage.md` for the `check` helper function).
- **NixOS/Home changes:** Prefer `nix eval` or `nixos-rebuild --flake` dry runs for targeted validation.
- **Formatting:** All Nix files must follow `nixfmt` conventions (`docs/formatting.md`).
- **Do not** modify or commit to `trivnixLib`, `trivnixConfigs`, or `trivnixPrivate` from this repo—reference their contracts only.

## Conventions & Patterns
- Inspect module files in `host/` or `home/` to trace option names before editing.
- Add new modules/options by following the structure in `host/common`, `host/modules`, `home/common`, and `home/modules`.
- Keep code comments minimal and purposeful, matching the project's style.
- For documentation, maintain a consistent tone and link to supporting guides in `docs/`.
- Respect uncommitted user changes; do not revert files you did not touch.

## Integration & External Dependencies
- Integrates with external repos: `trivnixLib`, `trivnixConfigs`, `trivnixPrivate` (see `docs/architecture.md`).
- Secrets and private inputs are required for some workflows; see `docs/secrets.md` and `docs/trivnix-private.md`.

## Examples
- To add a new host: follow the contract in `docs/adding-host.md` and place definitions in the appropriate directory.
- To add a new module: copy the pattern from `host/modules/` or `home/modules/` and update the relevant `modules.nix`.

## References
- **Architecture:** `docs/architecture.md`
- **Repo Structure:** `docs/repo-structure.md`
- **Getting Started:** `docs/getting-started.md`
- **Usage:** `docs/usage.md`
- **Formatting:** `docs/formatting.md`
- **Secrets:** `docs/secrets.md`

## When Blocked
- If a task cannot be completed due to missing secrets or private inputs, clearly state the blocker and reference the relevant documentation.

---

These instructions are tailored for AI agents to be productive and safe in the Trivnix codebase. Update this file as project conventions evolve.