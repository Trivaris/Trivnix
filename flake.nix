{
  description = ''
    Trivaris' NixOS Config.
  '';

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable?shallow=1";

    # Personal repos
    trivnixPrivate.url = "git+ssh://git@github.com/Trivaris/TrivnixPrivate";
    trivnixConfigs.url = "github:Trivaris/TrivnixConfigs";
    trivnixLib.url = "github:Trivaris/TrivnixLib";
    trivnixOverlays.url = "github:Trivaris/TrivnixOverlays";

    # Personal Forks
    millennium.url = "github:Trivaris/Millennium?dir=packages/nix";
    cfddns.url = "github:Trivaris/cloudflare-dyndns-nix";

    # Core/community modules
    disko.url = "github:nix-community/disko";
    nur.url = "github:nix-community/NUR";
    sops-nix.url = "github:Mic92/sops-nix";

    # Extras and ecosystem modules
    hyprland.url = "github:hyprwm/Hyprland";
    nix-minecraft.url = "github:Yeshey/nix-minecraft";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nvf.url = "github:notashelf/nvf";
    mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";

    # Non-flake sources
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
  };

  outputs = inputs: import ./flake/outputs.nix inputs;
}
