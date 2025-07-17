{
  config,
  lib,
  pkgs,
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
      description = "Port of vaultwarden";
    };
    domain = mkOption {
      type = types.str;
      description = "DNS name of vaultwarden";
    };
    email = mkOption {
      type = types.str;
      description = "Email for expiry reminders";
    };
  };

  config = mkIf cfg.vaultwarden.enable {

    networking.firewall.allowedTCPPorts = [ cfg.vaultwarden.port ];
    sops.secrets.vaultwarden-admin-token.path = envFile;

    services.vaultwarden = {
      enable = true;
      environmentFile = envFile;
      config = {
        DOMAIN = "https://${cfg.vaultwarden.domain}:${toString cfg.vaultwarden.port}";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        SIGNUPS_ALLOWED = true;
      };
    };
    
    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      appendHttpConfig = ''
        map $http_upgrade $connection_upgrade {
          default upgrade;
          \'\'      "";
        }
      '';

      virtualHosts.${cfg.vaultwarden.domain} = {
        forceSSL = true;
        default = true;
        useACMEHost = cfg.vaultwarden.domain;
        listen = [{
          addr = "0.0.0.0";
          port = cfg.vaultwarden.port;
          ssl = true;
        }];

        locations."/" = {
          proxyPass = "http://127.0.0.1:8222";
          proxyWebsockets = true;
          
          extraConfig = ''
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $http_cf_connecting_ip;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.vaultwarden.email;
      certs.${cfg.vaultwarden.domain} = {
        dnsProvider = "cloudflare";
        group = "nginx";
        credentialFiles = {
          "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets.cloudflare-api-token.path;
        };
      };
    };
    

  };

}
