{ config, lib, ... }:

let
  cfg = config.nixosModules;
  inherit (lib) mkEnableOption mkOption mkIf types mapAttrsToList filterAttrs;
  activeServices =
    builtins.filter (
      service: service.enable or false
    ) [
      cfg.codeServer
      cfg.nextcloud
      cfg.suwayomi
      cfg.vaultwarden
    ];
in
{
  options.nixosModules.reverseProxy = {
    enable = mkEnableOption "Reverse Proxy for enabled services";
    email = mkOption {
      type = types.str;
      description = "Email for interacting with Cloudflare API";
    };
    zone = mkOption {
      type = types.str;
      description = "DNS zone (e.g., example.com)";
    };
    port = mkOption {
      type = types.int;
      description = "External Port used to access the reverse Proxy";
    };
  };

  config = mkIf cfg.reverseProxy.enable {
    networking.firewall.allowedTCPPorts = [ cfg.reverseProxy.port ];

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
    };

    services.nginx.virtualHosts = builtins.listToAttrs (map (service: {
      name = service.domain;
      value = {
        forceSSL = true;
        useACMEHost = service.domain;
        listen = [{
          addr = "0.0.0.0";
          port = cfg.reverseProxy.port;
          ssl = true;
        }];
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString service.port}";
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
    }) activeServices);

    security.acme = {
      acceptTerms = true;
      certs = builtins.listToAttrs (map (service: {
        name = service.domain;
        value = {
          dnsProvider = "cloudflare";
          group = "nginx";
          email = cfg.reverseProxy.email;
          credentialFiles = {
            "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets.cloudflare-api-token.path;
          };
        };
      }) activeServices);
    };

    services.ddclient = {
      enable = true;
      protocol = "cloudflare";
      usev4 = "webv4,webv4=ipify-ipv4";
      ssl = true;
      verbose = true;
      zone = cfg.reverseProxy.zone;
      domains = map (service: service.domain) activeServices;
      username = "token";
      passwordFile = config.sops.secrets.cloudflare-api-account-token.path;
    };

  };

}
