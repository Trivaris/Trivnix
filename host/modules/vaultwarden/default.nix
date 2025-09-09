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
      config = {
        ADMIN_TOKEN = "$argon2id$v=19$m=65540,t=3,p=4$7q/+GP5hFwGIp8RG+/XDctDhkM3d+P0yaIBjx2Q6q4g$3eDxkpcfRopvzTtZUPTX387qiYTG1ACbRB6k5Td9ogI";
        DOMAIN = "https://${prefs.vaultwarden.reverseProxy.domain}:${toString prefs.reverseProxy.port}";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = prefs.vaultwarden.reverseProxy.port;
        SIGNUPS_ALLOWED = false;
      };
    };
  };
}
