{ config, lib, ... }:

let
  cfg = config.nixosConfig;
  inherit (lib) mkEnableOption mkOption mkIf types mapAttrsToList filterAttrs;
  activeServices =
    builtins.filter (
      service: service.enable or false
    ) [
      cfg.codeServer
      cfg.nextcloud
      cfg.suwayomi
      cfg.vaultwarden
      # cfg.minecraftServer
    ];

  externalPorts = builtins.map (service: service.externalPort) (
    builtins.filter (service: service.externalPort != null) activeServices
  );
in
{
  options.nixosConfig.reverseProxy = {
    enable = mkEnableOption "Enable reverse proxy for all enabled services.";

    email = mkOption {
      type = types.str;
      example = "admin@example.com";
      description = ''
        Email address used for Let's Encrypt/ACME certificate requests.
        Required for domain validation and renewal notices.
      '';
    };

    zone = mkOption {
      type = types.str;
      example = "example.com";
      description = ''
        The DNS zone managed by Cloudflare (e.g., your root domain).
        This is used to determine which domain records DDNS will update.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 443;
      description = ''
        External port on which Nginx will listen for HTTPS traffic.
        Commonly 443. Make sure this port is forwarded.
      '';
    };

    extraDomains = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "vpn.example.com" "blog.example.com" ];
      description = ''
        Additional FQDNs to include in DDNS updates.
        These do not need to be linked to services managed by this reverse proxy.
      '';
    };
    
    ddnsTime = mkOption {
      type = types.str;
      example = "04:00";
      description = ''
        Systemd OnCalendar timestamp to schedule DDNS updates with ddclient.
        Follows systemd time syntax. Examples:
          - "daily"
          - "04:00"
          - "Mon *-*-* 02:00:00"
      '';
    };
  };

  config = mkIf cfg.reverseProxy.enable {
    networking.firewall.allowedTCPPorts = [ cfg.reverseProxy.port ] ++ externalPorts;

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
          \'\'      close;
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
          port = if service.externalPort != null
                 then service.externalPort
                 else cfg.reverseProxy.port;
          ssl = true;
        }];

        locations."/" = {
          proxyPass = "http://${service.internalIP}:${toString service.port}";
          proxyWebsockets = true;
 
	        extraConfig = ''
            proxy_set_header Accept-Encoding gzip;
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
      domains = (map (service: service.domain) activeServices) ++ cfg.reverseProxy.extraDomains;
      username = "token";
      passwordFile = config.sops.secrets.cloudflare-api-account-token.path;
    };

    systemd.timers.ddclient = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.reverseProxy.ddnsTime;
        Persistent = true;
      };
    };

  };

}
