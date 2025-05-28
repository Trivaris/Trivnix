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
    nixpkgs,
    home-manager,
    disko, dotfiles,
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

    hosts = [
      {
        name = "trivlaptop";
        system = "x86_64-linux";
        users = [ "trivaris" ];
      }
    ];

    nixosConfigurations = builtins.listToAttrs (
      map (host: {
        name = host.name;
        value = nixpkgs.lib.nixosSystem {
          system = host.system;
          specialArgs = {
            inherit inputs outputs;
            hostInfo = host;
          };
          modules = [
            ./hosts/${host.name}
            disko.nixosModules.disko
          ];
        };
      }) hosts
    );

  in {
    inherit nixosConfigurations;

    packages = forAllSystems (system:
      import ./pkgs nixpkgs.legacyPackages.${system}
    );

    overlays = import ./overlays { inherit inputs; };
  };

}