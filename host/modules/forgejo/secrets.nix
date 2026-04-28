{
  lib,
  config,
  ...
}:
let 
  forgejoPrefs = config.hostPrefs.forgejo;
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
in
{
  config.sops.secrets = lib.mkIf forgejoPrefs.enable {
    mail-forgejo-password = {
      sopsFile = hostSecrets;
      owner = "forgejo";
      group = "forgejo";
    };
  };
}