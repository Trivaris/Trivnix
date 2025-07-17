{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules;
  domains = map (sub: "${sub}.${cfg.ddclient.zone}") cfg.ddclient.subdomains;
in
with lib;
{
  options.nixosModules.ddclient = {
    enable = mkEnableOption "DDNS";

    zone = mkOption {
      type = types.str;
      description = "DNS zone (e.g., example.com)";
    };

    subdomains = mkOption {
      type = with types; listOf str;
      default = [];
      description = "List of subdomains (e.g., [\"host\"] becomes host.${zone})";
    };

    protocol = mkOption {
      type = types.str;
      description = "Your DNS Provider";
    };

    email = mkOption {
      type = types.str;
      description = "Email for API Access";
    };
  };

  config = mkIf cfg.ddclient.enable {
    services.ddclient = {
      enable = true;
      protocol = cfg.ddclient.protocol;
      zone = cfg.ddclient.zone;
      domains = domains;
      username = cfg.ddclient.email;
      passwordFile = config.sops.secrets.cloudflare-api-token.path;
    };

  };

}