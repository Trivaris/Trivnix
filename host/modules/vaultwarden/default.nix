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
  options.hostPrefs.vaultwarden = import ./options.nix {
    inherit (lib) mkEnableOption;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf prefs.vaultwarden.enable {
    assertions = import ./assertions.nix { inherit prefs; };
    services.vaultwarden = {
      enable = true;
      environmentFile = config.sops.secrets.vaultwarden-admin-token.path;
      config = {
        DOMAIN = "https://${prefs.vaultwarden.reverseProxy.domain}:${toString prefs.reverseProxy.port}";
        ROCKET_ADDRESS = prefs.vaultwarden.reverseProxy.ipAddress;
        ROCKET_PORT = prefs.vaultwarden.reverseProxy.port;
        SIGNUPS_ALLOWED = false;
      }
      // (optionalAttrs prefs.vaultwarden.sendMails {
        SMTP_HOST = "127.0.0.1";
        SMTP_PORT = 25;
        SMTP_SSL = false;
        SMTP_FROM = "vaultwarden@${prefs.mailserver.baseDomain}";
        SMTP_FROM_NAME = "Vaultwarden";
      });
    };
  };
}
