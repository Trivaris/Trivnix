{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.nextcloud = {
    enable = mkEnableOption "nextcloud";
    domain = mkOption {
      type = types.str;
      description = "DNS name of nextcloud";
    };
    port = mkOption {
      type = types.int;
      description = "Port of nextcloud";
    };
    email = mkOption {
      type = types.str;
      description = "Email for expiry reminders";
    };
  };

  config = mkIf cfg.nextcloud.enable {

    networking.firewall.allowedTCPPorts = [ cfg.nextcloud.port ];

    services.nextcloud = {
      enable = true;
      hostName = cfg.nextcloud.domain;
      https = true;

      config = {
        adminuser = "admin";
        adminpassFile = config.sops.secrets.nextcloud-admin-token.path;
        dbtype = "pgsql";
      };

      database.createLocally = true;
      configureRedis = true;
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [{
        name = "nextcloud";
        ensureDBOwnership = true;
      }];
    };

    services.redis = {
      servers."${cfg.nextcloud.domain}" = {
        enable = true;
        unixSocketPerm = 770;
      };
    };

    users.users.nextcloud.extraGroups = [ "redis" ];

    services.nginx = {
      enable = true;
      virtualHosts.${cfg.nextcloud.domain} = {
        forceSSL = true;
        default = true;
        useACMEHost = cfg.nextcloud.domain;
        listen = [{
          addr = "0.0.0.0";
          port = cfg.nextcloud.port;
          ssl = true;
        }];
      };

      virtualHosts."${cfg.nextcloud.domain}-redirect" = {
        listen = [{
          addr = "0.0.0.0";
          port = cfg.nextcloud.port;
          ssl = false;
        }];
        serverName = cfg.nextcloud.domain;
        default = false;

        locations."/" = {
          return = "301 https://$host:${toString cfg.nextcloud.port}$request_uri";
        };
      };
    };

    systemd.services.lego.environment = {
      CLOUDFLARE_DNS_API_TOKEN_FILE = config.sops.secrets.cloudflare-api-token.path;
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
