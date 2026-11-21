{
  flake.nixosModules.networking-headscale =
    { lib, config, ... }:
    let
      hsPreferences = config.host.preferences.headscale;
      hsaclFile = "headscale/acl.hujson";
      stunPort = 3478;
    in
    {
      config = lib.mkIf hsPreferences.enable {
        networking.firewall.allowedUDPPorts = [ stunPort ];
        environment.systemPackages = [ config.services.headscale.package ];
        environment.etc."${hsaclFile}".text = builtins.toJSON {
          acls = [
            {
              action = "accept";
              src = [ "*" ];
              dst = [ "*:*" ];
            }
          ];
        };
        services.headscale = {
          enable = true;
          port = hsPreferences.reverseProxy.port;
          address = if hsPreferences.reverseProxy.enable then "127.0.0.1" else "0.0.0.0";
          settings = {
            log.level = "info";
            ephemeral_node_inactivity_timeout = "30m";
            server_url = "https://${hsPreferences.reverseProxy.domain}:${
              if hsPreferences.reverseProxy.enable then
                "443"
              else
                toString hsPreferences.reverseProxy.externalPort
            }";
            tls_letsencrypt_hostname =
              if hsPreferences.reverseProxy.enable then null else hsPreferences.reverseProxy.domain;

            dns = {
              magic_dns = true;
              base_domain = hsPreferences.dns.domain;
              nameservers.global = [
                "1.1.1.1"
                "9.9.9.9"
              ];
              extra_records = hsPreferences.dns.records;
            };

            prefixes = {
              v4 = "100.64.0.0/10";
              v6 = "fd7a:115c:a1e0::/48";
              allocation = "sequential";
            };

            derp = {
              server = {
                enabled = lib.mkDefault true;
                region_id = 999;
                region_code = "headscale";
                region_name = "Headscale Embedded DERP";
                stun_listen_addr = "0.0.0.0:${toString stunPort}";
                automatically_add_embedded_derp_region = true;
                verify_clients = true;
              };

              urls = [ "https://controlplane.tailscale.com/derpmap/default" ];
              auto_update_enabled = true;
            };

            policy = {
              mode = "file";
              path = "/etc/${hsaclFile}";
            };
          };
        };
      };
    };
}
