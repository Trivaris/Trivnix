{
  config,
  lib,
  ...
}:
let 
  vaultwardenPrefs = config.hostPrefs;
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
in
{
  config.sops.secrets = lib.mkIf vaultwardenPrefs.enable {
    vaultwarden-admin-token = {
      owner = "vaultwarden";
      group = "vaultwarden";
    };

    mail-vaultwarden-password = {
      sopsFile = hostSecrets;
      owner = "vaultwarden";
      group = "vaultwarden";
    };
  };
}