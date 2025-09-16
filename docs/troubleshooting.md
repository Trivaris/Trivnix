# Troubleshooting

- SOPS key missing: ensure `/var/lib/sops-nix/key.txt` exists during install.
- Private input access: `trivnixPrivate` requires your SSH key; verify agent forwarding or local key setup.
- Missing module effects: confirm the option path and spelling match available modules under `host/modules` or `home/modules`.
- Flake update issues: pin or roll back via `flake.lock`; verify input URLs are reachable.
