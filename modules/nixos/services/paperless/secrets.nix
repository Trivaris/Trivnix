{
  flake.nixosModules.services-paperless =
    {
      config,
      lib,
      ...
    }:
    let
      paperlessPreferences = config.host.preferences.paperless;
    in
    {
      config.sops.secrets = lib.mkIf paperlessPreferences.enable {
        paperless-admin-password = {
          sopsFile = config.host.private.secrets.hostSecretsFile;
          owner = "paperless";
          group = "paperless";
        };
      };
    };
}
