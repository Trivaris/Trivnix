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
      owner = "evolution-api";
      group = "evolution-api";
      sopsFile = hostSecrets;
    };
    evolution-api-postgres-env = {
      owner = "evolution-api";
      group = "evolution-api";
      sopsFile = hostSecrets;
    };
  };
}