{
  # Core Nixpkgs
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

  # Nix Community Modules
  home-manager = {
    url = "github:nix-community/home-manager";
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
  nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

  # Desktop/DE
  hyprland.url = "github:hyprwm/Hyprland";

  # Personal
  dotfiles = {
    url = "github:trivaris/dotfiles";
    flake = false;
  };
}
