{ trivnixConfigs, lib }:
let
  inherit (lib) mapAttrsToList unique;
in
unique (mapAttrsToList (_: config: config.infos.architecture) trivnixConfigs.configs)
