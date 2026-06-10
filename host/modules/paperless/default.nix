{
  config,
  lib,
  ...
}:
let
  paperlessPrefs = config.hostPrefs.paperless;
  secrets = config.sops.secrets;
in
{
  config = lib.mkIf paperlessPrefs.enable {
    services.paperless = {
      enable = true;
      domain = paperlessPrefs.reverseProxy.domain;
      port = paperlessPrefs.reverseProxy.port;
      passwordFile = secrets.paperless-admin-password.path;
      configureNginx = false;
      configureTika = true;
      exporter.enable = true;
    };
  };
}
