{
  homeModules,
  hostModules,
  lib,
  mkNixOS,
  trivnixConfigs,
}:
let
  inherit (lib) mapAttrs' nameValuePair;
in
mapAttrs' (
  configname: _:
  nameValuePair configname (mkNixOS {
    inherit configname homeModules hostModules;
  })
) trivnixConfigs.configs
