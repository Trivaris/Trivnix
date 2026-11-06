{
  description = ''
    Trivaris' NixOS Config.
  '';

  inputs = {
    # Core/community modules
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Framework tools
    flake-parts.url = "github:hercules-ci/flake-parts";
    nur.url = "github:nix-community/NUR";

    hyprqt6engine.url = "github:hyprwm/hyprqt6engine";
    hyprland.url = "github:hyprwm/Hyprland";

    epic-games-launcher = {
      url = "github:kjetteren/epic-games-launcher-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # mailserver = {
    #   url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.home-manager.flakeModules.home-manager
        inputs.flake-parts.flakeModules.easyOverlay
        ./lib
        ./modules/home
        ./modules/nixos
        ./modules/nixos/external.nix
        ./overlays
        ./packages
        ./shells
      ];
    };
}
