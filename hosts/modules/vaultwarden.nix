{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixosModules;
  envFile = "/etc/vaultwarden.env";
  cloudflareEnv = "/etc/cloudflare-api-token.env";
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
    sops.secrets.cloudflare-api-token.path = cloudflareEnv;
    sops.secrets.vaultwarden-admin-token.path = envFile;

    systemd.services.vaultwarden.serviceConfig.ReadOnlyPaths = [ pkgs.vaultwarden-web-vault ];
    services.vaultwarden = {
      enable = true;
      environmentFile = envFile;
      config = {
        WEB_VAULT_ENABLED = true;
        WEB_VAULT_FOLDER = "${pkgs.vaultwarden-web-vault}";
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

      virtualHosts.${cfg.vaultwarden.domain} = {
        forceSSL = true;
        default = true;
        useACMEHost = cfg.vaultwarden.domain;
        listen = [{
          addr = "0.0.0.0";
          port = cfg.vaultwarden.port;
          ssl = true;
        }];

        locations= {
        "/" = {
          proxyPass = "http://127.0.0.1:8222";
          proxyWebsockets = true;
        };
        };
      };

      virtualHosts."${cfg.vaultwarden.domain}-redirect" = {
        listen = [{
          addr = "0.0.0.0";
          port = cfg.vaultwarden.port;
          ssl = false;
        }];
        default = false;
        serverName = cfg.vaultwarden.domain;

        locations."/" = {
          return = "301 https://$host:${cfg.vaultwarden.port}$request_uri";
        };
      };

    };

    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.vaultwarden.email;
      certs.${cfg.vaultwarden.domain} = {
        dnsProvider = "cloudflare";
        environmentFile = cloudflareEnv; # must contain CLOUDFLARE_DNS_API_TOKEN
        group = "nginx";
      };
    };
    

  };

}
