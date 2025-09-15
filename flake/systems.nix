{ trivnixConfigs, lib }:
let
  inherit (lib) pipe mapAttrsToList unique;
in
pipe trivnixConfigs.configs [
  (mapAttrsToList (_: config: config.infos.architecture))
  unique
]
