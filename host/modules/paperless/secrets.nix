{
  config,
  lib,
  ...
}:
let
  paperlessPrefs = config.hostPrefs.paperless;
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
in 
{
  config.sops.secrets = lib.mkIf paperlessPrefs.enable {
    paperless-admin-password = {
      sopsFile = hostSecrets;
      owner = "paperless";
      group = "paperless";
    };
  };
}