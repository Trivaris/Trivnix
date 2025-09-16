# Trivnix – Coding Agent Guide

This document orients automated coding assistants that operate inside this repository. Follow it before making changes or running commands.

## 1. Understand the Repository
- Purpose: reusable NixOS and Home Manager modules plus overlays consumed alongside `trivnixLib`, `trivnixConfigs`, and `trivnixPrivate`.
- Start by skimming these docs:
  - `docs/architecture.md` – how flakes, modules, and external repos connect.
  - `docs/repo-structure.md` – directory map.
  - `docs/getting-started.md` and `docs/usage.md` – install/rebuild flow and module toggles.
  - `docs/adding-host.md` – contract for host and user definitions.
  - `docs/trivnix-private.md` and `docs/secrets.md` – required private inputs and SOPS layout.

## 2. Workspace Expectations
- The canonical flake inputs live in `flake.nix` with wiring under `flake/`.
- Never modify `trivnixLib`, `trivnixConfigs`, or `trivnixPrivate` here; reference their contracts instead.
- Respect any uncommitted user changes; do not revert files you did not touch.
- Format Nix files with `nixfmt` conventions (`docs/formatting.md`).
- Secrets are encrypted; do not attempt to decrypt or rewrite files under `secrets/` beyond expected path references.

## 3. Making Changes
- Before editing, inspect relevant module files inside `host/` or `home/` to trace option names.
- Keep code comments minimal and purposeful; match the project’s style.
- When adding options or modules, align with existing patterns (`host/common`, `host/modules`, `home/common`, `home/modules`).
- For docs, keep tone consistent with the existing guides and link to supporting references.

## 4. Testing and Validation
- Default validation command: `nix flake check` (see helper `check` function documented in `docs/usage.md`).
- For NixOS/Home changes, prefer `nix eval` or targeted `nixos-rebuild --flake` dry runs when needed.
- Avoid running commands that would require unavailable secrets or credentials.

## 5. Submitting Results
- Summaries should explain what changed, why, and point to affected paths.
- Suggest relevant follow-up actions (tests, commits, rebuilds) when appropriate.
- If you cannot complete a task because of missing inputs or secrets, respond with the blockers and reference the docs that explain the requirement.

By following this checklist, coding agents can work productively without breaking the conventions or contracts that Trivnix depends on.
