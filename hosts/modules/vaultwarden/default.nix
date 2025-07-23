{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosConfig;
in
with lib;
{
  options.nixosConfig.vaultwarden = import ./config.nix lib;

  config = mkIf cfg.vaultwarden.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        ADMIN_TOKEN = "$argon2id$v=19$m=65540,t=3,p=4$7q/+GP5hFwGIp8RG+/XDctDhkM3d+P0yaIBjx2Q6q4g$3eDxkpcfRopvzTtZUPTX387qiYTG1ACbRB6k5Td9ogI";
        DOMAIN = "https://${cfg.vaultwarden.domain}:${toString cfg.reverseProxy.port}";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = cfg.vaultwarden.port;
        SIGNUPS_ALLOWED = false;
      };
    };

  };
}
