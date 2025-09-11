{
  mkNixOS,
  trivnixConfigs,
  hostModules,
  homeModules,
  lib,
}:
lib.pipe trivnixConfigs.configs [
  (lib.mapAttrs' (
    configname: _:
    lib.nameValuePair configname (mkNixOS {
      inherit configname hostModules homeModules;
    })
  ))
]
