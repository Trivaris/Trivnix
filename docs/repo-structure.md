# Repository Structure

Key directories in this repo:

- `flake.nix`, `flake.lock`: flake inputs and locking
- `flake/`: split output wiring (`outputs.nix`, `modules.nix`, `nixosConfigurations.nix`, `homeConfigurations.nix`, etc.)
- `overlays/`: package overlays and custom packages
- `host/`
  - `common/`: shared NixOS settings (users, secrets, display manager, desktop env, services)
  - `modules/`: optional NixOS services (e.g., `wireguard`, `steam`, `codeServer`, `nextcloud`, etc.)
- `home/`
  - `common/`: shared user settings (shell, git, secrets, browsers)
  - `modules/`: reusable Home Manager modules (CLI tools, GUI apps, Hyprland, Waybar, etc.)
- `shared/`: shared configuration pieces (e.g., Stylix options)
- `secrets/`: encrypted secrets (see `docs/secrets.md` for layout)

External to this repo:

- `trivnixLib` (library functions)
- `trivnixConfigs` (host and user definitions)
- `trivnixPrivate` (private input)
