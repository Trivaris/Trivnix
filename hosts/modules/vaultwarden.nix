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
    sops.secrets.vaultwarden-admin-token.path = envFile;

    services.vaultwarden = {
      enable = true;
      environmentFile = envFile;
      config = {
        DOMAIN = "https://${cfg.vaultwarden.domain}:${toString cfg.reverseProxy.port}";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = cfg.vaultwarden.port;
        SIGNUPS_ALLOWED = true;
      };
    };

  };

}
