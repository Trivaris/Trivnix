{
  mkHomeManager,
  trivnixConfigs,
  homeModules,
  homeManagerModules,
  lib,
}:
let
  inherit (lib) concatMapAttrs mapAttrs' nameValuePair;
in
concatMapAttrs (
  configname: hostConfig:
  mapAttrs' (
    username: _:
    nameValuePair "${username}@${configname}" (mkHomeManager {
      inherit configname username;
      homeModules = homeModules ++ homeManagerModules;
    })
  ) hostConfig.users
) trivnixConfigs.configs
