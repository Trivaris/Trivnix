{ inputs, self, ... }:
let
  # Import lists of system architectures, hosts, and users
  systems = import ./systems.nix;
  hosts = import ./hosts.nix;
  users = import ./users.nix;

  # Helper functions to create NixOS and Home Manager configs
  pkgsLib = import ./mkPkgs.nix {
    inherit inputs;
    outputs = self.outputs;
  };

  nixosConfiguration = import ./nixosConfiguration.nix {
    inherit inputs pkgsLib;
    inherit (inputs)
      nixpkgs
      disko
      sops-nix
      home-manager
      nixos-wsl
      ;
    outputs = self.outputs;
  };

  homeConfiguration = import ./homeConfiguration.nix {
    inherit inputs pkgsLib;
    inherit (inputs) nixpkgs home-manager;
    outputs = self.outputs;
  };

  forAllSystems = inputs.nixpkgs.lib.genAttrs systems;

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
  homeConfigurations = builtins.listToAttrs (
    builtins.concatMap (
      username:
      builtins.map (configname: {
        name = "${username}@${hosts.${configname}.name}";
        value = homeConfiguration {
          hostname = hosts.${configname}.name;
          stateVersion = hosts.${configname}.stateVersion;
          configname = configname;
          username = username;
        };
      }) (builtins.attrNames hosts)
    ) users
  );

in
rec {
  # Packages for all defined systems
  packages = forAllSystems (
    arch:
    import ../pkgs {
      inherit inputs;
      pkgs = inputs.nixpkgs.legacyPackages.${arch};
    }
  );

  # Import custom overlays
  overlays = import ../overlays { inherit inputs; };

  inherit nixosConfigurations homeConfigurations;

}
