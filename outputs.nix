{ inputs, self }:
let
  outputs = self.outputs;
  libExtra = import ./libExtra { inherit inputs; };
  
  configs = builtins.removeAttrs libExtra.configs [ "homeServer" ];
  inherit (inputs.nixpkgs.lib) mapAttrs' nameValuePair concatMapAttrs;

  mkImports = base:
    (libExtra.resolveDir { dirPath = "/${base}/common"; mode = "paths"; }) ++
    (libExtra.resolveDir { dirPath = "/${base}/modules"; mode = "paths"; });
  
  homeImports = mkImports "home";
  hostImports = mkImports "hosts";

  mkHomeManager = import ./mkHomeManager.nix { inherit inputs outputs libExtra homeImports; };
  mkNixOS = import ./mkNixOS.nix { inherit inputs outputs libExtra hostImports homeImports; };

in
{
  overlays = import (libExtra.mkFlakePath /overlays) inputs;

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
