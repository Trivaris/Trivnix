{
  config,
  lib,
  ...
}:
let
  forgejoPrefs = config.hostPrefs.forgejo;
  mailserverPrefs = config.hostPrefs.mailserver;
  secrets = config.sops.secrets;
in
{
  config = lib.mkIf forgejoPrefs.enable {
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
          DOMAIN = forgejoPrefs.reverseProxy.domain;
          ROOT_URL = "https://${forgejoPrefs.reverseProxy.domain}/";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = forgejoPrefs.reverseProxy.port;
        };

        mailer = lib.optionalAttrs forgejoPrefs.sendMails {
          ENABLED = true;
          PROTOCOL = "smtp";
          SMTP_ADDR = "127.0.0.1";
          SMTP_PORT = 25;
          FROM = "no-reply@forgejo.${mailserverPrefs.domain}";
        };
      };
    };

    hostPrefs.mailserver = {
      extraDomains = lib.mkIf forgejoPrefs.sendMails [ "forgejo" ];
      accounts."no-reply@forgejo.${mailserverPrefs.domain}".passwordFile = secrets.mail-forgejo-password.path;
    };
  };
}
