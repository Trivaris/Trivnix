{
  mkNixOS,
  trivnixConfigs,
  hostModules,
  homeModules,
  lib,
}:
let
  inherit (lib) mapAttrs' nameValuePair;
in
mapAttrs' (
  configname: _:
  nameValuePair configname (mkNixOS {
    inherit configname hostModules homeModules;
  })
) trivnixConfigs.configs
