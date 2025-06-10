 Trivnix

## Introduction

Trivnix is a flake-based NixOS configuration used to manage my personal machines. It aims to provide reproducible and portable system setups using declarative Nix expressions. The repository currently targets a laptop and a Windows Subsystem for Linux (WSL) installation but can be extended for additional hosts.

## Table of Contents
- [Features](#features)
- [Repository Structure](#repository-structure)
- [Installation](#installation)
- [Usage](#usage)
- [Dependencies](#dependencies)
- [Configuration](#configuration)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Contributors](#contributors)
- [License](#license)

## Features
- **Flake-based setup** with inputs for `nixpkgs`, `home-manager`, `disko`, and `sops-nix`.
- **Host definitions** for a laptop and WSL instance using the `nixosConfiguration` helper.
- **Home‑manager integration** for user environments, imported via `homeConfiguration`.
- **Hardware modules** including automated disk layouts using `disko`.
- **Secrets management** with `sops-nix` to deploy encrypted credentials.
- **Custom packages** such as `r-matrix` and `rbonsai` provided via overlays.
- **Optional modules** enabling services like Bluetooth, OpenSSH, printing and more.

## Repository Structure
```
.
├── flake.nix           # Main flake entry point
├── flake.lock          # Locked input versions
├── hosts/              # System configurations for each host
├── home/               # Home-manager modules per user
├── modules/            # Reusable home-manager configuration modules
├── overlays/           # Package overlays
├── pkgs/               # Custom package definitions
├── resources/          # Wallpapers, secrets, SSH keys
└── README.md           # This file
```

- **hosts/** contains a `common` profile and hardware specific directories such as `laptop` and `wsl`.
- **home/** contains user specific setups; for example the laptop configuration imports several modules automatically.
- **modules/** contains home-manager configs shared between users; for example nvim or fish.

## Installation

1. Install [NixOS](https://nixos.org/download.html).

2. Clone this repository on the target machine **or** copy only the following files:
   - `install.sh`
   - `keys.txt`
   - Your disko config file: `<configname>.nix`

3. Place `keys.txt` in the **same directory** as `install.sh`.

4. Run the installer:

   ```bash
   ./install.sh --nixos-cfg <host-platform (laptop/wsl/etc)> --disko-cfg <configname>
   ```
5. About `--disko-cfg`
    - If `--disko-cfg` is not provided, it defaults to `default`.

    - The script searches for the disko config file in the following order:
        1. `<configname>.nix` in the **same directory** as `install.sh`
        2. If not found, falls back to `../hosts/common/hardware/<configname>.nix`

    - This allows you to either:
        - Use a local disko config directly next to the script (for quick overrides), or  
        - Rely on the shared configuration structure in the repository.

## Usage
- Update flake inputs with `nix flake update`.
- Rebuild the system with `sudo nixos-rebuild switch --flake .#<hostname>`.
- Update the user environment using `home-manager switch --flake .#<user>@<hostname>`.

## Dependencies
- Nix 2.7 or later
- `nixpkgs` channels specified in `flake.nix`
- [`home-manager`](https://github.com/nix-community/home-manager)
- [`disko`](https://github.com/nix-community/disko) for disk layout generation
- [`sops-nix`](https://github.com/Mic92/sops-nix) for secret management
- `age`/`gpg` keys for decrypting secrets

## Configuration
- Host options live under `hosts/<host>` and inherit common modules from `hosts/common`.
- Home‑manager modules reside in `modules/` and can be added or removed from each user configuration.
- Secrets are stored in `resources/secrets.yaml` and decrypted by `sops-nix` at build time.
- Optional features can be toggled by modifying the list in `hosts/<host>/default.nix` or by editing the module lists in the corresponding user files.

## Troubleshooting
- Ensure your secrets key is available when building; otherwise `sops-nix` will fail.
- When using WSL, verify that required mounts exist and the kernel supports the listed modules.
- If a module or package is missing, check that the overlay paths and module imports are correct.

## Contributors
- **Trivaris** – original author and maintainer.
- Inspired by work from [**m3tam3re**](https://www.youtube.com/watch?v=43VvFgPsPtY&list=PLCQqUlIAw2cCuc3gRV9jIBGHeekVyBUnC).
- Folder Structure inspired by [**EmergentMind**](https://github.com/EmergentMind/nix-config)

## License
MIT License: Tu', was du nicht lassen kannst.