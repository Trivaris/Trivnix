{
  config,
  lib,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf optionalAttrs;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.forgejo = import ./options.nix {
    inherit (lib) mkEnableOption;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf prefs.forgejo.enable {
    assertions = import ./assertions.nix { inherit prefs; };
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

        mailer = optionalAttrs prefs.forgejo.sendMails {
          ENABLED = true;
          PROTOCOL = "smtp";
          SMTP_ADDR = "127.0.0.1";
          SMTP_PORT = 25;
          FROM = "forgejo@trivaris.org";
        };
      };
    };
  };
}
