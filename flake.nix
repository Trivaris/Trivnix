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
    nixpkgs-legacy.url = "github:NixOS/nixpkgs/0f2efa91a6b70089b92480ba613571e92322f753";

    dotfiles = {
      url = "github:trivaris/dotfiles";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      disko,
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

      legacyPkgsFor =
        system:
        import inputs.nixpkgs-legacy {
          inherit system;
          config.permittedInsecurePackages = [ "nodejs-10.24.1" ];
        };

      hosts = {
        trivlaptop = {
          name = "trivlaptop";
          users = [ users.trivaris ];
          system = "x86_64-linux";
        };
      };

      users = {
        trivaris = {
          name = "trivaris";
        };
      };

      userHostPairs = builtins.listToAttrs (
        builtins.concatMap (
          host:
          builtins.map (user: {
            name = "${user.name}@${host.name}";
            value = { inherit host; };
          }) host.users
        ) (builtins.attrValues hosts)
      );

      extraArgsModule = host: {
        home-manager = {
          config = {
            home-manager.extraSpecialArgs = {
              inherit inputs outputs host;
              legacyPkgs = legacyPkgsFor host.system;
            };
          };
        };
        nixos = {
          inherit inputs outputs host;
          legacyPkgs = legacyPkgsFor host.system;
        };
      };

      nixosConfiguration =
        host:
        let
          extraArgs = extraArgsModule host;
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = extraArgs.nixos;
          modules = [
            ./hosts/${host.name}
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            (extraArgs.home-manager)
          ];
        };

      homeConfiguration =
        pair:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${pair.host.system};
          extraSpecialArgs = {
            inherit inputs outputs pair;
            legacyPkgs = legacyPkgsFor pair.host.system;
          };
          modules = [ ./home/${pair.user.name}/${pair.host.name}.nix ];
        };

    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = builtins.mapAttrs (_: nixosConfiguration) hosts;
      homeConfigurations = builtins.mapAttrs (_: homeConfiguration) userHostPairs;
    };

}
