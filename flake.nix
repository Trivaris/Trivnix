{
  description = ''
    Trivaris' NixOS Config. Built on top of m3tam3re's series.
  '';

  # Centralize input definitions
  inputs = {
    # Core Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # Nix Community Modules
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gradle2nix = {
      url = "github:tadfisher/gradle2nix?ref=v2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Sources of Custom Packages
    rmatrix-src = {
      url = "github:Fierthraix/rmatrix";
      flake = false;
    };
    rbonsai-src = {
      url = "github:roberte777/rbonsai";
      flake = false;
    };
    suwayomi-server-src = {
      url = "github:Suwayomi/Suwayomi-Server-preview";
      flake = false;
    };
    suwayomi-webui-src = {
      url = "github:Suwayomi/Suwayomi-WebUI-preview";
      flake = false;
    };
    udp-proxy-2020-src = {
      url = "github:synfinatic/udp-proxy-2020";
      flake = false;
    };

    # Personal
    dotfiles = {
      url = "github:trivaris/dotfiles";
      flake = false;
    };
  };

  # Delegate output logic to separate module
  outputs =
    inputs@{ self, ... }:
    import ./flake/outputs.nix {
      inherit inputs self;
    };
}
