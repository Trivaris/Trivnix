{ trivnixConfigs, lib }:
lib.pipe trivnixConfigs.configs [
  (lib.mapAttrsToList (_: config: config.infos.architecture))
  lib.unique
]
