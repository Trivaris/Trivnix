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

      hosts = {
        wsl = {
          name = "trivwsl";
          stateVersion = "24.11";
        };
        laptop = {
          name = "trivlaptop";
          stateVersion = "25.05";
        };
      };

      users = [ "trivaris" ];

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
          stateVersion,
          architecture ? "x86_64-linux",
          usernames ? [ "trivaris" ],
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              outputs
              hostname
              stateVersion
              configname
              architecture
              ;
            usernames = usernames ++ [ "root" ];
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
                  stateVersion
                  architecture
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
          stateVersion,
          architecture ? "x86_64-linux",
          username,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${architecture};
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              hostname
              stateVersion
              username
              architecture
              configname
              ;
          };
          modules = [
            "./home/${username}/${configname}.nix"
          ];
        };

      nixosConfigurations = builtins.mapAttrs (
        host: cfg:
        nixosConfiguration {
          hostname = cfg.name;
          configname = host;
          stateVersion = cfg.stateVersion;
        }
      ) hosts;

      homeConfigurations = builtins.listToAttrs (
        builtins.concatMap (
          username:
          builtins.map (configname: {
            name = "${username}@${hosts.${configname}.name}";
            value = homeConfiguration {
              hostname = hosts.${configname}.name;
              stateVersion = hosts.${configname}.stateVersion;
              inherit configname username;
            };
          }) (builtins.attrNames hosts)
        ) users
      );

    in
    {
      packages = forAllSystems (architecture: import ./pkgs nixpkgs.legacyPackages.${architecture});
      overlays = import ./overlays { inherit inputs; };

      inherit nixosConfigurations homeConfigurations;

    };

}
