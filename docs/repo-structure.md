# Repository Structure

Key directories in this repo:

- `flake.nix`, `flake.lock`: flake inputs and locking
- `outputs.nix`: defines outputs using helpers from `trivnix-lib` and configs from `trivnix-configs`
- `overlays/`: package overlays and custom packages
- `host/`
  - `common/`: shared NixOS settings (users, secrets, display manager, desktop env, services)
  - `modules/`: optional NixOS services (e.g., `wireguard`, `steam`, `codeServer`, `nextcloud`, etc.)
- `home/`
  - `common/`: shared user settings (shell, git, secrets, browsers)
  - `modules/`: reusable Home Manager modules (CLI tools, GUI apps, Hyprland, Waybar, etc.)
- `shared/`: shared configuration pieces (e.g., Stylix options)
- `secrets/`: secrets documentation and example layout (encrypted with SOPS)
- `resources/`: scripts and static assets (e.g., wallpapers, config files outside nixos)

External to this repo:

- `trivnix-lib` (library functions)
- `trivnix-configs` (host and user definitions)
- `trivnix-private` (private input)

