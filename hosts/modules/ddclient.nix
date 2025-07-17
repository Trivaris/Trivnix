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
      description = "List of subdomains (e.g., [\"host\"] becomes host.${zone})";
    };

    email = mkOption {
      type = types.str;
      description = "Email for API Access";
    };
  };

  config = mkIf cfg.ddclient.enable {
    services.ddclient = {
      enable = true;
      protocol = "cloudflare";
      usev4 = "webv4,webv4=ipify-ipv4";
      ssl = true;
      verbose = true;
      zone = cfg.ddclient.zone;
      domains = domains;
      username = "token";
      passwordFile = config.sops.secrets.cloudflare-api-account-token.path;
    };

  };

}