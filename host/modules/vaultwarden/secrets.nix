{
  config,
  lib,
  ...
}:
let
  vaultwardenPrefs = config.hostPrefs.vaultwarden;
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
  commonSecrets = "${config.private.secrets}/host/common.yaml";
in
{
  config.sops.secrets = lib.mkIf vaultwardenPrefs.enable {
    vaultwarden-admin-token = {
      sopsFile = commonSecrets;
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
