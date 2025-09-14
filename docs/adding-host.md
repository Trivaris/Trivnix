# Configs Flake Contract

Define your hosts and users in your own flake and expose them under `outputs.configs`.
Trivnix consumes only this contract — your internal layout is up to you.

## Required Shape

Your flake must return an attribute set like the following (one entry per host, this example is not exhaustive):

```nix
outputs = { self, ... }: {
  configs = {
    <configname> = {
      infos = {
        name = "myhost";               # visible hostname
        architecture = "x86_64-linux"; # system architecture, cpu-os
        stateVersion = "25.05";        # NixOS/Home Manager stateVersion
        ip = "192.168.1.42";           # used for SSH aliases/services
        hardwareKey = false;           # true if using -sk SSH keys like Yubikey. Assumes two per host
        hashedRootPassword = "...";    # YESCRYPT hash for root
      };

      # Host-level preferences consumed by host modules in this repo
      prefs = {
        displayManager = "gdm";             # e.g. "gdm" | "sddm"
        desktopEnvironment = "kde";         # e.g. "kde" | "hyprland"
        language.keyMap = "de";             # keyboard layout

        # Module toggles (examples)
        openssh.enable = true;
        bluetooth.enable = true;
        printing.enable = true;
        wireguard.enable = false;
        steam.enable = false;
        kdeConnect.enable = false;

        # Theming using Stylix
        stylix = {
          darkmode = true;
          colorscheme = "rose-pine-moon";
        };
      };

      # Users on this host
      users = {
        <user> = {
          infos.hashedPassword = "..."; # YESCRYPT user hash
          prefs = {
            shell = "fish";
            terminalEmulator = "alacritty";
            browsers = [ "librewolf" ];
            gui = [ "vscodium" ];
            cli = [ "bat" "fzf" ];
            git.email = "alice@example.com";
          };
        };
      };

      pkgsConfig = { allowUnfree = true; };

      # Optional extras
      pubKeys = {
        "host.pub" = "ssh-ed25519 AAAA...";   # used for known_hosts/authorized_keys
      };
    };
  };
};
```

## Secrets

Provide the required AGE/SOPS secrets for each host and user as described in `secrets/README.md` of this repo. Ensure your `.sops.yaml` policy allows the new host and its users to decrypt their files.

## Using Your Configs With Trivnix

You can point this repo to your configs flake without editing files using `--override-input`:

```bash
sudo nixos-rebuild switch \
  --flake github:trivaris/trivnix#<configname> \
  --override-input trivnixConfigs github:<you>/<your-configs-repo>
```

If working from a local clone and you prefer a permanent link, you can also edit this repo’s `flake.nix` input `trivnixConfigs` to your repository and then run:

```bash
sudo nixos-rebuild switch --flake .#<configname>
```

Remote deploy works the same with `--target-host <user>@<ip> --sudo`.

