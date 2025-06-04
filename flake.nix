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
      nixosConfiguration =
        {
          configname,
          hostname,
          systemArchitechture ? "x86_64-linux",
          usernames ? [ "trivaris" ],
          isWsl ? false,
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              outputs
              hostname
              configname
              usernames
              isWsl
              systemArchitechture
              ;
          };
          modules = [
            ./hosts/${configname}
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            {
              config.home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  outputs
                  hostname
                  configname
                  isWsl
                  systemArchitechture
                  ;
              };
            }
          ];
        };

      # Home Config Preset
      homeConfiguration =
        {
          configname,
          hostname,
          systemArchitechture ? "x86_64-linux",
          username,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${systemArchitechture};
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              hostname
              username
              systemArchitechture
              configname
              ;
          };
          modules = [
            sops-nix.nixosModules.sops
            ./home/${username}/${configname}.nix
          ];
        };

    in
    {
      packages = forAllSystems (
        systemArchitechture: import ./pkgs nixpkgs.legacyPackages.${systemArchitechture}
      );
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations.laptop = nixosConfiguration {
        hostname = "trivlaptop";
        configname = "laptop";
      };

      nixosConfigurations.wsl = nixosConfiguration {
        hostname = "trivwsl";
        configname = "wsl";
        isWsl = true;
      };

      homeConfigurations."trivaris@trivlaptop" = homeConfiguration {
        hostname = "trivlaptop";
        configname = "laptop";
        username = "trivaris";
      };

      nixosTests = forAllSystems (
        system:
          {
            openssh = import ./tests/openssh.nix { inherit inputs system; };
            hyprland = import ./tests/hyprland.nix { inherit inputs system; };
          }
      );

    };

}
