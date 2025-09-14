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
  options.hostPrefs.vaultwarden = import ./options.nix {
    inherit (lib) mkEnableOption;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf prefs.vaultwarden.enable {
    services.vaultwarden = {
      enable = true;
      environmentFile = config.sops.secrets.vaultwarden-admin-token.path;
      config = {
        DOMAIN = "https://${prefs.vaultwarden.reverseProxy.domain}:${toString prefs.reverseProxy.port}";
        ROCKET_ADDRESS = prefs.vaultwarden.reverseProxy.ipAddress;
        ROCKET_PORT = prefs.vaultwarden.reverseProxy.port;
        SIGNUPS_ALLOWED = false;
      };
    };
  };
}
