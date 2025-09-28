{
  description = ''
    Trivaris' NixOS Config.
  '';

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable?shallow=1";

    # Personal repos
    trivnixPrivate.url = "git+ssh://git@github.com/Trivaris/TrivnixPrivate";

    trivnixLib = {
      url = "github:Trivaris/TrivnixLib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    trivnixConfigs = {
      url = "github:Trivaris/TrivnixConfigs";
      inputs.trivnixLib.follows = "trivnixLib";
    };

    trivnixOverlays = {
      url = "github:Trivaris/TrivnixOverlays";
      inputs.trivnixLib.follows = "trivnixLib";
    };

    # Personal Forks
    # millennium.url = "github:Trivaris/Millennium";
    adbAutoPlayer = {
      url = "github:Trivaris/AdbAutoPlayer/config-overhaul";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Core/community modules
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Extras and ecosystem modules
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Yeshey/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixowos = {
      url = "github:yunfachi/nixowos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Non-flake sources
    appflowy = {
      url = "github:appflowy-io/AppFlowy-Cloud";
      flake = false;
    };

    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
  };

  outputs = inputs: import ./flake/outputs.nix inputs;
}
