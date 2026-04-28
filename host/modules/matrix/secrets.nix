{
  lib,
  config,
  ...
}:
let 
  matrixPrefs = config.hostPrefs.matrix;
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
in 
{
  config.sops.secrets = lib.mkIf matrixPrefs.enable {
    matrix-secrets = {
      sopsFile = hostSecrets;
      owner = "root";
      group = "root";
    };
  };
}