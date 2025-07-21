## Introduction

Trivnix is a flake-based NixOS configuration used to manage my personal machines. It aims to provide reproducible and portable system setups using declarative Nix expressions. The repository currently targets a laptop and a Windows Subsystem for Linux (WSL) installation but can be extended for additional hosts.

---

## Table of Contents
- [Features](#features)
- [Design Goals](#design-goals)
- [Repository Structure](#repository-structure)
- [Installation](#installation)
- [Usage](#usage)
- [Extending the Configuration](#extending-the-configuration)
- [Host Configuration Context](#host-configuration-context)
- [Home Configuration Context](#home-configuration-context)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Contributors](#contributors)
- [License](#license)

---

## Features
- **Flake-based setup** with inputs for `nixpkgs`, `home-manager`, `disko`, and `sops-nix`.
- **Host definitions** (e.g. desktop, laptop, WSL) with support for arbitrary instances via `nixosConfiguration`.
- **Home‑manager integration** for per-user customization, imported via `homeConfiguration`.
- **Hardware modules** including automated disk layouts using `disko`.
- **Secrets management** with `sops-nix` to deploy encrypted credentials.
- **Custom packages** such as `r-matrix` and `rbonsai` provided via overlays.
- **Optional modules** enabling services like Bluetooth, OpenSSH, printing and more.

---

## Design Goals
- Minimal mutable state
- Hardware abstraction
- Secrets separation
- Low-friction onboarding for new machines

---

## Repository Structure
```
.
.
├── .gitignore           # Ignore files (e.g. keys, build outputs)
├── flake.nix            # Main Nix flake entry point
├── flake.lock           # Locked flake input versions
├── LICENSE              # MIT License
├── README.md            # This file
│
├── flake/               # Flake logic for hosts, home configs, and utilities
│   ├── hosts/           # Host definitions (desktop, laptop, WSL, etc.)
│   └── libExtra/        # Helper functions (e.g. mkFlakePath)
│
├── home/                # Home Manager configurations
│   ├── common/          # Shared user settings (e.g. secrets, programs)
│   ├── configurations/  # Per-host user configurations
│   └── modules/         # Reusable Home Manager modules (e.g. nvim, fish)
│
├── hosts/               # NixOS system configurations
│   ├── common/          # Shared host settings (e.g. users, secrets)
│   ├── configurations/  # Per-host system + hardware configuration
│   └── modules/         # Shared NixOS modules (e.g. openssh, bluetooth)
│
├── overlays/            # Package overlays
│   └── pkgs/            # Custom and patched packages
│
├── partitions/          # Partition layout definitions
├── resources/           # Static assets (e.g. wallpapers, SSH keys)
└── secrets/             # Encrypted credentials (e.g. sops-nix)

```

---

## Installation
0. Add your [secrets](./secrets/README.md)

1. Boot into the [NixOS ISO](https://nixos.org/download.html).

2. Clone this repository on the target machine

### Option A: Automatic Install (Recommended)
3. Place host `key.txt` in the **same directory** as `install.sh`.

4. Run the [installer](./resources/install.sh):

   ```bash
   ./install.sh --nixos-cfg <host-platform (laptop/wsl/etc)> [--disko-cfg <configname>] [--reboot]
   ```
5. About `--disko-cfg`, `--reboot`
    
    - If `--disko-cfg` is not provided, it defaults to `default`.

    - The script searches for the disko config file in `../partitions/disko-<configname>.nix`.

    - If `--reboot` is set, the installer will automatically reboot upon completion of installation.

    - The disko version is taken from `flake.lock` to keep installations reproducible.

### Option B: Manual Installation (More Reliable)
3. Place host `key.txt` in `/mnt/var/lib/sops-nix/key.txt`

4. Format your disk with disko
  ```bash
  sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /path/to/disko-config.nix
  ```

5. Install nixos
  ```bash
  sudo nixos install --flake github:trivaris/trivnix.git
  ```

---

## Usage
- Update flake inputs with `nix flake update`.
- Rebuild the system with `sudo nixos-rebuild switch --flake .#<hostname>`.
- Update the user environment using `home-manager switch --flake .#<user>@<hostname>` (not extensively tested).

---

## Extending the Configuration

### Adding New Hosts and Users

See [`./NEW_HOST.md`](./NEW_HOST.md) for a step-by-step guide.

---

### Host Configuration Context

The following variables are available in host-level NixOS configurations:

| Name          | Description                                                             |
| ------------- | ----------------------------------------------------------------------- |
| `configname`  | Abstract hostname (e.g., `desktop`, `laptop`, `wsl`, `server`)          |
| `hostconfig`  | Configuration for the current host. See `/flake/hosts/<configname>.nix` |
| `userconfigs` | All user configurations for the current host, including enabled modules |
| `hosts`       | All host configurations in the system                                   |
| `libExtra`    | Utility functions, e.g., `mkFlakePath`, from `/flake/libExtra`          |

### Home Configuration Context

In addition to the above, the following is available in Home Manager modules:

| Name         | Description                                                  |
| ------------ | ------------------------------------------------------------ |
| `userconfig` | Configuration of the current user, including enabled modules |

---

## Module Activation Example

To enable optional modules such as `openssh` or `bluetooth`, set them in your host module:

```nix
{
  nixosConfig = {
    openssh.enable = true;
    bluetooth.enable = true;
  };
}
```

This will include `./hosts/modules/openssh.nix` and `bluetooth.nix` automatically if structured accordingly.

---

## Configuration
- Host and Home options live under `flake/hosts/<host>` and inherit common modules from `hosts/common`.
- Modules reside in `home/modules/` and `hosts/modules/` and can be added or removed from each user configuration.
- Secrets are stored in `secrets/` and decrypted by `sops-nix` at build time.
- NixOS and Home Manager Optional features can be toggled and configured by modifying the set in `flake/hosts/<host>.nix`

---

## Troubleshooting
- Ensure your secrets key is available when building; otherwise `sops-nix` will fail.
- When using WSL, verify that required mounts exist and the kernel supports the listed modules.
- If a module or package is missing, check that the overlay paths and module imports are correct.

---

## Contributors
- **Trivaris** – original author and maintainer.
- Inspired by work from [**m3tam3re**](https://www.youtube.com/watch?v=43VvFgPsPtY&list=PLCQqUlIAw2cCuc3gRV9jIBGHeekVyBUnC).
- Folder Structure inspired by [**EmergentMind**](https://github.com/EmergentMind/nix-config)

---

## License

Licensed under the [MIT License](./LICENSE).
