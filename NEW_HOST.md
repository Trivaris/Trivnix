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
    homeModules = {
      module.enable = true;    # Enable home module(s) from /home/modules
      git.email = "user@example.com"; # Git identity
    };
  };

  nixosModules = {
    module.enable = true;      # Enable NixOS module(s) from /hosts/modules
  };
}
```

---

### 2. Define System Configuration

Create or edit `/hosts/configurations/<configname>.nix`:

```nix
{ libExtra, hostconfig, ... }:

{
  imports = [
    (libExtra.mkFlakePath /hosts/common)
    (libExtra.mkFlakePath /hosts/modules)
  ];

  config.nixosModules = hostconfig.nixosModules;
}
```

---

### 3. Register the Host

In `/hosts/configurations/default.nix`, add your host to the exported set:

```nix
{
  <configname> = import ./<configname>.nix;
}
```

### 4. Define your Home Configuration
Create or edit `/home/configurations/<username>.nix`

```nix
{ libExtra, userconfigs, ... }:

{
  imports = [
    (libExtra.mkFlakePath /home/common)
    (libExtra.mkFlakePath /home/modules)
  ];
  homeModules = userconfigs.username.homeModules;
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
