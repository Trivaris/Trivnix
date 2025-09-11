{
  mkHomeManager,
  trivnixConfigs,
  homeModules,
  homeManagerModules,
  lib,
}:
lib.pipe trivnixConfigs.configs [
  (lib.concatMapAttrs (
    configname: hostConfig:
    lib.pipe hostConfig.users [
      (lib.mapAttrs' (
        username: _:
        lib.nameValuePair "${username}@${configname}" (mkHomeManager {
          inherit configname username;
          homeModules = homeModules ++ homeManagerModules;
        })
      ))
    ]
  ))
]
