{
  flake.nixosModules.networking-headscale =
    { lib, config, ... }:
    let
      hsPreferences = config.host.preferences.headscale;
      stunPort = 3478;
    in
    {
      config = lib.mkIf hsPreferences.enable {
        networking.firewall.allowedUDPPorts = [ stunPort ];
        environment.systemPackages = [ config.services.headscale.package ];
        services.headscale = {
          enable = true;
          port = hsPreferences.reverseProxy.port;
          address = if hsPreferences.reverseProxy.enable then "127.0.0.1" else "0.0.0.0";
          settings = {
            log.level = "info";
            node.ephemeral.inactivity_timeout = "30m";
            policy.mode = "database";
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
              ] ++ hsPreferences.dns.nameservers;
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
          };
        };
        services.headplane = {
          enable = true;
          settings = {
            server = {
              host = "127.0.0.1";
              port = 3010;
              cookie_secret_path = config.sops.secrets.headplane-cookie.path;
            };
            headscale = {
              url =
                if hsPreferences.reverseProxy.enable then
                  "http://127.0.0.1:${toString config.services.headscale.port}"
                else
                  config.services.headscale.settings.server_url;
              public_url = config.services.headscale.settings.server_url;
              config_path = "/etc/headscale/config.yaml";
            };
          };
        };
        sops.secrets.headplane-cookie = {
          sopsFile = config.host.private.secrets.hostSecretsFile;
          owner = config.systemd.services.headplane.serviceConfig.User;
          group = config.systemd.services.headplane.serviceConfig.Group;
          mode = "0400";
        };
      };
    };
}
