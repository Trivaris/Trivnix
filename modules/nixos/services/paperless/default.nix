{
  imports = [
    ./options.nix
    ./secrets.nix
  ];

  flake.nixosModules.services-paperless =
    {
      config,
      lib,
      ...
    }:
    let
      paperless-prefs = config.host-prefs.paperless;
      secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf paperless-prefs.enable {
        services.paperless = {
          enable = true;
          domain = paperless-prefs.reverseProxy.domain;
          port = paperless-prefs.reverseProxy.port;
          passwordFile = secrets.paperless-admin-password.path;
          configureNginx = false;
          configureTika = true;
          exporter.enable = true;
        };
      };
    };
}
