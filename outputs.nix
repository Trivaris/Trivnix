{ inputs, self }:
let
  outputs = self.outputs;
  libExtra = import ./libExtra { inherit inputs; };
  
  inherit (libExtra) configs;
  inherit (inputs.nixpkgs.lib) mapAttrs' nameValuePair;
  
  mkHomeManager = import ./mkHomeManager.nix { inherit inputs outputs libExtra; };
  mkNixOS = import ./mkNixOS.nix { inherit inputs outputs libExtra; };
in
{
  overlays = import (libExtra.mkFlakePath /overlays) inputs;

  # Define NixOS configs for each host
  # Format: configname = <NixOS config>
  nixosConfigurations = mapAttrs' (name: value:
    nameValuePair name (mkNixOS { configname = name; })
  ) configs;

  # Define Home Manager configs for each user@hostname
  # Format: <user>@<hostname> (configname) = <Home Manager config>
  homeConfigurations = mapAttrs' (configname: hostconfig:
    mapAttrs' (username: userconfig:
      nameValuePair
        "${username}@${configname}"
        mkHomeManager { inherit configname username; }
    ) hostconfig.users
  ) configs;
}
