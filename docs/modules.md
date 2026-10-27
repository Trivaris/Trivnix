# Module Catalog

The default module exports are grouped by their configuration target. Most feature modules expose an enable option and additional settings under `hostPrefs` or `userPrefs`.

## Host services

- **Web and routing:** reverse proxy, ACME, Anubis, TCP forwarding, Cloudflare DDNS, and service virtual hosts
- **Productivity and collaboration:** Affine, Collabora, Evolution API, Matrix, Paperless, Tandoor, and Actual
- **Development and hosting:** Forgejo, code-server, n8n, and Homepage
- **Communication and identity:** mailserver, Vaultwarden, OpenSSH, and SOPS integration
- **Networking:** WireGuard, OpenConnect, Pi-hole, and Syncthing
- **Monitoring:** Glances and service status integration

## Host platform

The host tree also covers boot and GRUB, users, Home Manager integration, locale and keymap, fingerprint authentication, PipeWire, shell defaults, SSH, and general NixOS settings. Steam is available as a host feature module.

## Home Manager and desktop

- **Desktop:** Hyprland, Quickshell, Kitty, Rofi, and theming
- **CLI:** shell functions, Starship, bat, eza, fzf, zoxide, and Fastfetch
- **Applications:** LibreWolf, Thunderbird, VS Code, Prism Launcher, Remmina, WayVNC, direnv, and Neovim
- **Accounts and identity:** email, Git, SSH, and SOPS-backed user configuration

The module files are the source of truth for behavior. Use the [option reference](reference/README.md) for exact option paths and defaults.
