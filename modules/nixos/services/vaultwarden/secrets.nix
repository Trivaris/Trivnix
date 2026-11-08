{
  flake.nixosModules.services-vaultwarden =
    {
      config,
      lib,
      ...
    }:
    let
      vaultwardenPreferences = config.host.preferences.vaultwarden;
      hostSecrets = "${config.private.secrets}/host/${config.host.info.configName}.yaml";
      commonSecrets = "${config.private.secrets}/host/common.yaml";
    in
    {
      config.sops.secrets = lib.mkIf vaultwardenPreferences.enable {
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
    };
}
