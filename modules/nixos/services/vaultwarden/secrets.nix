{
  flake.nixosModules.services-vaultwarden =
    {
      config,
      lib,
      ...
    }:
    let
      vaultwarden-prefs = config.host-prefs.vaultwarden;
      host-secrets = "${config.private.secrets}/host/${config.host-infos.configname}.yaml";
      common-secrets = "${config.private.secrets}/host/common.yaml";
    in
    {
      config.sops.secrets = lib.mkIf vaultwarden-prefs.enable {
        vaultwarden-admin-token = {
          sopsFile = common-secrets;
          owner = "vaultwarden";
          group = "vaultwarden";
        };

        mail-vaultwarden-password = {
          sopsFile = host-secrets;
          owner = "vaultwarden";
          group = "vaultwarden";
        };
      };
    };
}
