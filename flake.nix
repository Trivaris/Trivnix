{

  description = ''
    Trivaris' NixOS Config. Built on top of m3tam3re's series.
  '';

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # Nix Community
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

    # Personal
    dotfiles = {
      url = "github:trivaris/dotfiles";
      flake = false;
    };
  };

  outputs =
    {
      self,

      nixpkgs,
      nixpkgs-stable,
      
      home-manager,
      disko,
      sops-nix,

      dotfiles,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # NixOS Config Preset
      nixosConfiguration = {
        hostname, 
        system, 
        users
      }: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs hostname users system; };
        modules = [
          ./hosts/${hostname}
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          { config.home-manager.extraSpecialArgs = { inherit inputs outputs hostname system; }; }
        ];
      };

      # Home Config Preset
      homeConfiguration = {
        hostname, 
        system, 
        username
      }: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs outputs hostname username system; };
        modules = [
          sops-nix.nixosModules.sops
          ./home/${username}/${hostname}.nix
        ];
      };

    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations."trivlaptop" = nixosConfiguration {
        hostname = "trivlaptop";
        system = "x86_64-linux";
        users = [ "trivaris" ];
      };

      homeConfigurations."trivaris@trivlaptop" = homeConfiguration {
        hostname = "trivlaptop";
        system = "x86_64-linux";
        username = "trivaris";
      };

    };

}
