{
  config,
  lib,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.forgejo = import ./config.nix {
    inherit (lib) mkEnableOption;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf prefs.forgejo.enable {
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
      };
    };
  };
}
