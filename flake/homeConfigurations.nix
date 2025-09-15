{
  mkHomeManager,
  trivnixConfigs,
  homeModules,
  homeManagerModules,
  lib,
}:
let
  inherit (lib)
    pipe
    concatMapAttrs
    mapAttrs'
    nameValuePair
    ;
in
pipe trivnixConfigs.configs [
  (concatMapAttrs (
    configname: hostConfig:
    pipe hostConfig.users [
      (mapAttrs' (
        username: _:
        nameValuePair "${username}@${configname}" (mkHomeManager {
          inherit configname username;
          homeModules = homeModules ++ homeManagerModules;
        })
      ))
    ]
  ))
]
