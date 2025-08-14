## How to Add a New Host in Your Nix Flake

### 1. Define the Host

Create a new file at:
`/flake/hosts/<configname>.nix`

Example structure:

```nix
{
  name = "my-host";            # Hostname (used for config naming and system identification)
  stateVersion = "24.05";      # Match your system's NixOS version
  hardwareKey = true;          # Use YubiKey (if true, switches to -sk keys: -a and -c for USB-A/C)

  ip = "192.168.1.42";         # Static/local IP used for SSH targeting
  architecture = "x86_64-linux"; # e.g., "aarch64-linux" for ARM

  users.username = {
    homeConfig = {
      module.enable = true;    # Enable home module(s) from /home/modules
      git.email = "user@example.com"; # Git identity
    };
  };

  hostPrefs = {
    module.enable = true;      # Enable NixOS module(s) from /hosts/modules
  };
}
```

---

### 2. Define System Config

Create or edit `/hosts/configs/<configname>.nix`:

```nix
{ trivnixLib, hostconfig, ... }:

{
  imports = [
    (trivnixLib.mkFlakePath /hosts/common)
    (trivnixLib.mkFlakePath /hosts/modules)
  ];

  config.hostPrefs = hostconfig.hostPrefs;
}
```

---

### 3. Register the Host

In `/hosts/configs/default.nix`, add your host to the exported set:

```nix
{
  <configname> = import ./<configname>.nix;
}
```

### 4. Define your Home Config
Create or edit `/home/configs/<username>.nix`

```nix
{ trivnixLib, userconfigs, ... }:

{
  imports = [
    (trivnixLib.mkFlakePath /home/common)
    (trivnixLib.mkFlakePath /home/modules)
  ];
  homeConfig = userconfigs.username.homeConfig;
}
```

---

### 5. Register User Config

In `/home/default.nix`, define each user once:

```nix
{
  <username> = import ./<username>.nix;
}
```

---

### 6. Add Secrets

Follow the instructions in `/secrets/README.md` to:

* Add necessary secrets for your host under:

  * `/secrets/hosts/<configname>.yaml`
  * `/secrets/home/<username>/<configname>.yaml`
* Make sure the corresponding entries are present in your `sops` secrets config.

---

### Done

Now you can run:

```bash
nixos-rebuild switch --flake .#<configname>
```

Or deploy remotely:

```bash
nixos-rebuild switch --flake .#<configname> --target-host <user>@<ip> --use-remote-sudo
```
