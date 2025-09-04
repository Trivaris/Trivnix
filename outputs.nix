{ inputs, self }:
let
  outputs = self.outputs;
  trivnixLib = inputs.trivnix-lib.lib.for self;

  inherit (inputs.trivnix-configs) configs commonInfos;
  inherit (inputs.nixpkgs.lib) mapAttrs' nameValuePair concatMapAttrs;

  mkHomeManager = import ./mkHomeManager.nix {
    inherit
      inputs
      outputs
      trivnixLib
      configs
      commonInfos
      ;
  };
  mkNixOS = import ./mkNixOS.nix {
    inherit
      inputs
      outputs
      trivnixLib
      configs
      commonInfos
      ;
  };
in
{
  inherit configs;
  overlays = (import ./overlays) inputs;

  # Define NixOS configs for each host
  # Format: configname = <NixOS config>
  nixosConfigurations = mapAttrs' (
    configname: _:
    nameValuePair configname (mkNixOS {
      inherit configname;
    })
  ) configs;

  # Define Home Manager configs for each user@hostname
  # Format: <user>@<hostname> (configname) = <Home Manager config>
  homeConfigurations = concatMapAttrs (
    configname: hostConfig:
    mapAttrs' (
      username: userconfig:
      nameValuePair "${username}@${configname}" (mkHomeManager {
        inherit configname username;
      })
    ) hostConfig.users
  ) configs;
}
