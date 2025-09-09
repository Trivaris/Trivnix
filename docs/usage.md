# Usage

Common tasks and how to toggle modules.

## Rebuild

- Update inputs: `nix flake update`
- NixOS switch: `sudo nixos-rebuild switch --flake .#<configname>`
- Home switch: `home-manager switch --flake .#<user>@<configname>`

## Dev Helpers (Fish)

If your `userPrefs.shell` is `"fish"`, this config adds handy functions for local development. They live in `home/common/shell/fish.nix` and appear in your shell after switching.

- `rebuild-prod <host>`: Rebuilds using locked inputs from `flake.lock`.
- `check-prod [path=. ]`: Runs `nix flake check` with locked inputs.
- `rebuild-dev <host>`: Same as `rebuild-prod`, but overrides inputs to local checkouts:
  - `~/Projects/trivnix-configs/`
  - `~/Projects/trivnix-lib/`
  - `~/Projects/trivnix-private/`
  Use this to iterate on modules/configs without committing or updating locks.
- `check-dev [path=. ]`: Runs `nix flake check` with the same local overrides.

Notes

- Ensure those directories exist and are valid flakes; otherwise overrides will fail.
- Dev overrides only affect evaluation; they don’t modify `flake.lock`.

## Toggle Host Modules

Host-level preferences live in `trivnix-configs.configs.<configname>.prefs` and map to `host/common` and `host/modules` here.
User-level preferences live in `trivnix-configs.configs.<configname>.users.<user>.prefs` and map to `home/common` and `home/modules` here.

Examples:

```nix
<configname>.prefs = {
  steam.enable = true;             # host/modules/steam
  wireguard.enable = true;         # host/modules/wireguard
  displayManager = "gdm";          # host/common/displayManager
  desktopEnvironment.name = "kde"; # or "hyprland"
  
  users.<user>.prefs = {
    browsers = [ "librewolf" ];
    terminalEmulator = "alacritty";
    shell = "fish";

    gui = [ "vscodium" "bitwarden" "spotify" ];
    cli = [ "bat" "btop" "eza" "fzf" "nvim" "zoxide" ];

    email.enable = true;
    vscodium.enableLsp = true;
    git.email = "you@example.com";
  };
}
```

Refer to the modules under `home/modules` and `host/modules` for the available options.
