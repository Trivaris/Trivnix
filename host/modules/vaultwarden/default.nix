{
  config,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.vaultwarden.enable {
    services.vaultwarden = {
      enable = true;
      environmentFile = config.sops.secrets.vaultwarden-admin-token.path;
      config = {
        DOMAIN = "https://${prefs.vaultwarden.reverseProxy.domain}:${toString prefs.reverseProxy.port}";
        ROCKET_ADDRESS = prefs.vaultwarden.reverseProxy.ipAddress;
        ROCKET_PORT = prefs.vaultwarden.reverseProxy.port;
        SIGNUPS_ALLOWED = false;
      }
      // (lib.optionalAttrs prefs.vaultwarden.sendMails {
        SMTP_SSL = false;
        SMTP_HOST = "127.0.0.1";
        SMTP_PORT = 25;
        SMTP_FROM = "vaultwarden@${prefs.mailserver.baseDomain}";
        SMTP_FROM_NAME = "Vaultwarden";
      });
    };
  };
}
