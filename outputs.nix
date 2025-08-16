{ inputs, self }:
let
  outputs = self.outputs;
  trivnixLib = inputs.trivnix-lib.lib.for self;
  
  inherit (inputs.trivnix-configs) configs;
  inherit (inputs.nixpkgs.lib) mapAttrs' nameValuePair concatMapAttrs;

  mkImports = base:
    (trivnixLib.resolveDir { dirPath = "/${base}/common"; mode = "paths"; }) ++
    (trivnixLib.resolveDir { dirPath = "/${base}/modules"; mode = "paths"; });
  
  homeImports = mkImports "home";
  hostImports = mkImports "hosts";

  mkHomeManager = import ./mkHomeManager.nix { inherit inputs outputs trivnixLib homeImports configs; };
  mkNixOS = import ./mkNixOS.nix { inherit inputs outputs trivnixLib hostImports homeImports configs; };
in
{
  overlays = import (trivnixLib.mkFlakePath /overlays) inputs;

  # Define NixOS configs for each host
  # Format: configname = <NixOS config>
  nixosConfigurations = mapAttrs' (configname: _:
    nameValuePair configname (mkNixOS { inherit configname; })
  ) configs;

  # Define Home Manager configs for each user@hostname
  # Format: <user>@<hostname> (configname) = <Home Manager config>
  homeConfigurations = concatMapAttrs (configname: hostConfig:
    mapAttrs' (username: userconfig:
      nameValuePair "${username}@${configname}" (mkHomeManager {
        inherit configname username;
      })
    ) hostConfig.users
  ) configs;
}
