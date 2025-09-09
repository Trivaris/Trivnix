# Troubleshooting

- SOPS key missing: ensure `/var/lib/sops-nix/key.txt` exists during install.
- Private input access: `trivnix-private` requires your SSH key; verify agent forwarding or local key setup.
- WSL quirks: validate mounts and kernel modules if using WSL modules.
- Missing module effects: confirm the option path and spelling match available modules under `host/modules` or `home/modules`.
- Flake update issues: pin or roll back via `flake.lock`; verify input URLs are reachable.

