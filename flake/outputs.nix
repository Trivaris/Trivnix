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
          };
        }
      ) (lib.attrNames hosts)
    ) users
  );

in
{
  # Packages for all defined systems
  packages = forAllSystems (
    arch:
    import ../overlays/additions {
      inherit inputs;
      pkgs = inputs.nixpkgs.legacyPackages.${arch};
    }
  );

  # Import custom overlays
  overlays = import ../overlays { inherit inputs; };

  inherit nixosConfigurations homeConfigurations;

}
