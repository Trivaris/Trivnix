{ lib, ... }:
{
  options.hostPrefs.reverseProxy = {
    enable = lib.mkEnableOption ''
      the shared Nginx reverse proxy for web services.
      Services defining `reverseProxy` register with it automatically.
    '';

    enableDDClient = lib.mkEnableOption ''
      ddclient for dynamic DNS updates for the configured zone.
      Useful when public IPs change and Cloudflare or other providers must sync.
    '';

    email = lib.mkOption {
      type = lib.types.str;
      example = "admin@example.com";

      description = ''
        Email address used for Let's Encrypt/ACME certificate requests.
        Required for domain validation and renewal notices.
      '';
    };

    zone = lib.mkOption {
      type = lib.types.str;
      example = "example.com";

      description = ''
        The DNS zone managed by Cloudflare (e.g., your root domain).
        This is used to determine which domain records DDNS will update.
      '';
    };

    extraCertDomains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];

      example = [
        "vpn.example.com"
        "blog.example.com"
      ];

      description = ''
        Additional FQDNs to include in HTTPS Cert generation.
        These do not need to be linked to services managed by this reverse proxy.
      '';
    };

    extraDDNSDomains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];

      example = [
        "vpn.example.com"
        "blog.example.com"
      ];

      description = ''
        Additional FQDNs to include in DDNS updates.
        These do not need to be linked to services managed by this reverse proxy.
      '';
    };

    ddnsTime = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "04:00";

      description = ''
        Systemd OnCalendar expression controlling when ddclient runs.
        Leave null to disable the timer or provide values like "daily" or "04:00".
      '';
    };

    extraServices = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule (
          lib.recursiveUpdate lib.reverseProxyOptions {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                description = "Name used to identify the additional reverse-proxy service.";
              };
            };
          }
        )
      );
      default = [ ];
      description = ''
        Additional services to register with the shared reverse proxy.
        Each entry extends the standard reverse-proxy service options with a name.
      '';
    };

    dumbPipes = {
      enable = lib.mkEnableOption ''
        non-HTTP forwarding rules handled by the shared reverse proxy.
      '';

      upstreams = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              address = lib.mkOption {
                type = lib.types.str;
                description = "Address of the upstream service.";
              };
              port = lib.mkOption {
                type = lib.types.port;
                default = 443;
                description = "Port of the upstream service.";
              };
            };
          }
        );
        default = { };
        description = ''
          Named upstream addresses used by dumb forwarding rules.
        '';
      };

      fallbackPort = lib.mkOption {
        type = lib.types.port;
        default = 8443;
        description = ''
          Port used when a dumb forwarding rule does not specify another target.
        '';
      };

      pipes = lib.mkOption {
        description = ''
          TCP forwarding rules selected by the requested SNI hostname.
        '';
        type = lib.types.attrsOf lib.types.str;
        default = { };
      };

      portForwards = lib.mkOption {
        description = ''
          Raw TCP port forwarding for protocols without SNI, such as SSH.
        '';
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              listenPort = lib.mkOption {
                type = lib.types.port;
                description = "Local port that accepts forwarded connections.";
              };
              upstream = lib.mkOption {
                type = lib.types.str;
                description = "Address and port of the forwarding destination.";
              };
              enableTCP = lib.mkEnableOption "TCP port forwarding";
              enableUDP = lib.mkEnableOption "UDP port forwarding";
            };
          }
        );
        default = { };
      };
    };
  };
}
