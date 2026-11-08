{
  flake.nixosModules.services-paperless =
    {
      config,
      lib,
      ...
    }:
    let
      paperlessPreferences = config.host.preferences.paperless;
      hostSecrets = "${config.private.secrets}/host/${config.host.info.configName}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf paperlessPreferences.enable {
        paperless-admin-password = {
          sopsFile = hostSecrets;
          owner = "paperless";
          group = "paperless";
        };
      };
    };
}
