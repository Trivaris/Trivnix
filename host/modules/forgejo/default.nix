{
  config,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.forgejo.enable {
    services.forgejo = {
      enable = true;
      lfs.enable = true;
      database.type = "postgres";

      settings = {
        session.COOKIE_SECURE = true;
        service.DISABLE_REGISTRATION = true;

        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };

        server = {
          DOMAIN = prefs.forgejo.reverseProxy.domain;
          ROOT_URL = "https://${prefs.forgejo.reverseProxy.domain}/";
          HTTP_ADDR = prefs.forgejo.reverseProxy.ipAddress;
          HTTP_PORT = prefs.forgejo.reverseProxy.port;
        };

        mailer = lib.optionalAttrs prefs.forgejo.sendMails {
          ENABLED = true;
          PROTOCOL = "smtp";
          SMTP_ADDR = "127.0.0.1";
          SMTP_PORT = 25;
          FROM = "no-reply@forgejo.${prefs.mailserver.domain}";
        };
      };
    };

    hostPrefs.mailserver = {
      extraDomains = lib.mkIf prefs.forgejo.sendMails [ "forgejo" ];
      accounts."no-reply@forgejo.${prefs.mailserver.domain}".passwordFile = config.sops.secrets.mail-forgejo-password.path;
    };
  };
}
