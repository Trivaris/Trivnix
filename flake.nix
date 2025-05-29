{
  
  description = ''
    Trivaris' NixOS Config. Built on top of m3tam3re's series.
  '';

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    dotfiles = {
      url = "github:trivaris/dotfiles";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    disko,
    dotfiles,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

  in {

    packages = forAllSystems ( system: import (inputs.self + "/pkgs/") nixpkgs.legacyPackages.${system} );
    overlays = import ./overlays { inherit inputs; };
    
    nixosConfigurations.trivlaptop = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs;
      };
      modules = [
        ./hosts/trivlaptop
        disko.nixosModules.disko
      ];
    };

  };

}