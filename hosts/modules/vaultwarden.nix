{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules;
  envFile = "/etc/vaultwarden.env";
in
with lib;
{

  options.nixosModules.vaultwarden = {
    enable = mkEnableOption "vaultwarden";
    port = mkOption {
      type = types.int;
      default = 8891;
      description = "Internal Port used by the reverse Proxy";
    };
    domain = mkOption {
      type = types.str;
      description = "DNS name";
    };
  };

  config = mkIf cfg.vaultwarden.enable {

    networking.firewall.allowedTCPPorts = [ cfg.vaultwarden.port ];

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
