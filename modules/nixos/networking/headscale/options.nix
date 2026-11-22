{
  flake.nixosModules.networking-headscale = { lib, ... }: {
    options.host.preferences.headscale = {
      enable = lib.mkEnableOption "Headscale, an open source implementation of tailscale's admin dashboard";
      reverseProxy = lib.trivnix.mkReverseProxyOption;
      dns = {
        domain = lib.mkOption {
          type = lib.types.str;
          description = "FQDN for the DNS Server";
        };
        nameservers = lib.mkOption {
          type = lib.types.attrsOf (lib.types.listOf lib.types.str);
          description = "Additional nameservers for specific domains";
          default = { };
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
  };
}
