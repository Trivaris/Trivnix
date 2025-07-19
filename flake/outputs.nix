{ inputs, self, ... }:
let
  outputs = self.outputs;

  # Import lists of system architectures, hosts, and users
  systems = import ./systems.nix;
  hosts = import ./hosts.nix;
  users = import ./users.nix;

  # Helper functions to create NixOS and Home Manager configs
  lib = inputs.nixpkgs.lib;
  forAllSystems = lib.genAttrs systems;

  libExtra = import ./libExtra {
    inherit inputs outputs;
  };

  nixosConfiguration = import ./nixosConfiguration.nix {
    inherit inputs outputs libExtra;
    inherit (inputs)
      nixpkgs
      disko
      sops-nix
      home-manager
      nixos-wsl
      ;
  };

  homeConfiguration = import ./homeConfiguration.nix {
    inherit inputs outputs libExtra;
    inherit (inputs) nixpkgs home-manager;
  };

  # Define NixOS configurations for each host
  # Format: configname = <NixOS config>
  nixosConfigurations = builtins.mapAttrs (
    host: cfg:
    nixosConfiguration {
      hostname = cfg.name;
      configname = host;
      stateVersion = cfg.stateVersion;
      hardwareKey = cfg.hardwareKey;
      hosts = hosts;
      users = users;
    }
  ) hosts;

  # Define Home Manager configurations for each user@hostname
  # Format: <user>@<hostname> (configname) = <Home Manager config>
  homeConfigurations = lib.listToAttrs (
    lib.concatMap (
      username:
      lib.map (
        configname:
        let
          hostCfg = hosts.${configname};
        in
        {
          name = "${username}@${configname}";
          value = homeConfiguration {
            hostname = hostCfg.name;
            stateVersion = hostCfg.stateVersion;
            configname = configname;
            username = username;
            hardwareKey = hostCfg.hardwareKey;
            hosts = hosts;
            users = users;
          };
        }
      ) (lib.attrNames hosts)
    ) users
  );

  # Import custom overlays
  overlays = import (libExtra.mkFlakePath /overlays) { inherit inputs; };

in
{
  # Packages for all defined systems
  packages = forAllSystems (system:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = with overlays; [ additions modifications stable-packages nur minecraft ];
        config.allowUnfree = true;
      };
    in {
      inherit (pkgs) rmatrix rbonsai suwayomi-server;
    }
  );

  inherit nixosConfigurations homeConfigurations overlays;

}
