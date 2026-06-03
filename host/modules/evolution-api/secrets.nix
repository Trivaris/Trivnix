{
  lib,
  config,
  ...
}:
let
  evolutionPrefs = config.hostPrefs.evolution;
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
in
{
  config.sops.secrets = lib.mkIf evolutionPrefs.enable {
    evolution-api-env = {
      sopsFile = hostSecrets;
      owner = "evolution-api";
      group = "evolution-api";
    };
    evolution-api-postgres-env = {
      sopsFile = hostSecrets;
      owner = "evolution-api";
      group = "evolution-api";
    };
  };
}
