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

    # Sources of Custom Packages
    rmatrix-src = {
      url = "github:Fierthraix/rmatrix";
      flake = false;
    };
    rbonsai-src = {
      url = "github:roberte777/rbonsai";
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
