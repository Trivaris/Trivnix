{
  flake.nixosModules.networking-headscale = { lib, ... }: {
    options.host.preferences = {
      headscale = {
        enable = lib.mkEnableOption "Headscale, an open source implementation of tailscale's admin dashboard";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
        stunPort = lib.mkOption {
          type = lib.types.port;
          default = 3478;
          description = "The port of the STUN/DERP server";
        };
        ipv4Subnet = lib.mkOption {
          type = lib.types.str;
          default = "100.64.0.0/10";
          description = "The ipv4 subnet used by tailscale vpn";
        };
        ipv6Subnet = lib.mkOption {
          type = lib.types.str;
          default = "fd7a:115c:a1e0::/48";
          description = "The ipv6 subnet used by tailscale vpn";
        };
        dns = {
          domain = lib.mkOption {
            type = lib.types.str;
            description = "FQDN for the DNS Server";
          };
          nameservers = lib.mkOption {
            type = lib.types.attrsOf (lib.types.listOf lib.types.str);
            default = { };
            description = "Additional nameservers for specific domains";
          };
          globalNameservers = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "1.1.1.1"
              "9.9.9.9"
            ];
            description = "Additional nameservers for any domains";
          };
          records = lib.mkOption {
            type = lib.types.listOf (
              lib.types.submodule {
                options = {
                  name = lib.mkOption {
                    type = lib.types.str;
                    description = "DNS record name";
                  };
                  type = lib.mkOption {
                    type = lib.types.enum [
                      "A"
                      "AAAA"
                    ];
                    description = "DNS record type";
                  };
                  value = lib.mkOption {
                    type = lib.types.str;
                    description = "DNS record value (IP address)";
                  };
                };
              }
            );
            default = [ ];
          };
        };
      };
      headplane = {
        enable = lib.mkEnableOption "Headplane, a frontend for headtail";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
        ipAddr = lib.mkOption {
          type = lib.types.str;
          description = "The Tailscale ip address of headplane";
        };
      };
    };
  };
}
