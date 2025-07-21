{ inputs, self, ... }:
let
  outputs = self.outputs;
  lib = inputs.nixpkgs.lib;

  # Import lists of system architectures, hosts, and users
  hosts = import ./hosts;
  architectures = lib.unique (
    lib.mapAttrsToList (_: host: host.architecture) hosts
  );

  # Helper functions to create NixOS and Home Manager configs  
  forAllArchitectures = lib.genAttrs architectures;

  libExtra = import ./libExtra {
    inherit inputs outputs;
  };

  nixosConfiguration = libExtra.mkNixOSConfiguration {
    inherit inputs outputs libExtra;
  };

  homeConfiguration = libExtra.mkHomeConfiguration {
    inherit inputs outputs libExtra;
  };

  # Import custom overlays
  overlays = import (libExtra.mkFlakePath /overlays) { inherit inputs libExtra; };
in
{
  inherit overlays;

  # Packages for all defined architectures
  packages = forAllArchitectures (architecture:
    let
      pkgs = import inputs.nixpkgs {
        system = architecture;
        overlays = with overlays; [ additions modifications stable-packages nur minecraft ];
        config.allowUnfree = true;
      };
    in {
      inherit (pkgs)
        rmatrix
        rbonsai 
        suwayomi-server;
    }
  );

  # Define NixOS configurations for each host
  # Format: configname = <NixOS config>
  nixosConfigurations = builtins.mapAttrs (
    configname: rawHost:
    let
      userconfigs = rawHost.users or {};
      hostconfig = rawHost // {
        users = builtins.attrNames userconfigs;
      };
      flatHosts = builtins.mapAttrs(_: host:
        host // {
          users = builtins.attrNames (host.users or {});
        }
      ) hosts;
    in
    nixosConfiguration {
      inherit
        configname
        hostconfig
        userconfigs;
      hosts = flatHosts;
    }
  ) hosts;

  # Define Home Manager configurations for each user@hostname
  # Format: <user>@<hostname> (configname) = <Home Manager config>
  homeConfigurations = builtins.listToAttrs (
    lib.concatMap (configname:
      let
        rawHost = hosts.${configname};
        userconfigs = rawHost.users or {};
        hostconfig = rawHost // { users = builtins.attrNames userconfigs; };
      in
        map (username: {
          name = "${username}@${configname}";
          value = homeConfiguration {
            inherit username configname hostconfig hosts;
            userconfig = userconfigs.${username} // { name = username; };
          };
        }) (builtins.attrNames userconfigs)
    ) (builtins.attrNames hosts)
  );
}
