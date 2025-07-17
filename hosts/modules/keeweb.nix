{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixosModules;
  cloudflareEnv = "/etc/cloudflare-api-token.env";
in
with lib;
{

  options.nixosModules.keeweb = {
    enable = mkEnableOption "keeweb";
    domain = mkOption {
      type = types.str;
      description = "DNS name of keeweb";
    };
    port = mkOption {
      type = types.int;
      description = "Port of keeweb";
    };
    email = mkOption {
      type = types.str;
      description = "Email for expiry reminders";
    };
  };

  config = mkIf cfg.keeweb.enable {

    networking.firewall.allowedTCPPorts = [ cfg.keeweb.port ];
    sops.secrets.cloudflare-api-token.path = cloudflareEnv;

    services.nginx = {
      enable = true;
      virtualHosts.${cfg.keeweb.domain} = {
        forceSSL = true;
        default = true;
        useACMEHost = cfg.keeweb.domain;
        listen = [{
          addr = "0.0.0.0";
          port = cfg.keeweb.port;
          ssl = true;
        }];

        locations= {
          "/" = {
            root = "${pkgs.keeweb}";
            index = "index.html";
          };
        };
      };

      virtualHosts."${cfg.keeweb.domain}-redirect" = {
        listen = [{
          addr = "0.0.0.0";
          port = cfg.keeweb.port;
          ssl = false;
        }];
        serverName = cfg.keeweb.domain;
        default = false;

        locations."/" = {
          return = "301 https://${cfg.keeweb.domain}$request_uri";
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.keeweb.email;
      certs.${cfg.keeweb.domain} = {
        dnsProvider = "cloudflare";
        environmentFile = cloudflareEnv;
        group = "nginx";
      };
    };
    

  };

}
