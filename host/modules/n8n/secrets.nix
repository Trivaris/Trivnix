{
  lib,
  config,
  ...
}:
let 
  n8nPrefs = config.hostPrefs.n8n;
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
in
{
  config.sops.secrets = lib.mkIf n8nPrefs.enable {
    n8n-runner-auth-token = {
      sopsFile = hostSecrets;
      owner = "root";
      group = "root";
    };
  };
}