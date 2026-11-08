{
  flake.nixosModules.services-paperless =
    {
      config,
      lib,
      ...
    }:
    let
      paperlessPreferences = config.host.preferences.paperless;
      secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf paperlessPreferences.enable {
        services.paperless = {
          enable = true;
          domain = paperlessPreferences.reverseProxy.domain;
          port = paperlessPreferences.reverseProxy.port;
          passwordFile = secrets.paperless-admin-password.path;
          configureNginx = false;
          configureTika = true;
          exporter.enable = true;
        };
      };
    };
}
