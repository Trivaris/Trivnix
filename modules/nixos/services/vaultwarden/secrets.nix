{
  flake.nixosModules.services-vaultwarden =
    {
      config,
      lib,
      ...
    }:
    let
      vaultwardenPreferences = config.host.preferences.vaultwarden;
    in
    {
      config.sops.secrets = lib.mkIf vaultwardenPreferences.enable {
        vaultwarden-admin-token = {
          sopsFile = config.host.private.secrets.commonSecretsFile;
          owner = "vaultwarden";
          group = "vaultwarden";
        };

        mail-vaultwarden-password = {
          sopsFile = config.host.private.secrets.hostSecretsFile;
          owner = "vaultwarden";
          group = "vaultwarden";
        };
      };
    };
}
