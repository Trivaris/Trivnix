{
  flake.nixosModules.networking-headscale =
    { lib, config, ... }:
    let
      hsPreferences = config.host.preferences.headscale;
      hpPreferences = config.host.preferences.headplane;
      piPreferences = config.host.preferences.pocket-id;
    in
    {
      config = lib.mkIf hsPreferences.enable {
        networking.firewall.allowedUDPPorts = [ hsPreferences.stunPort ];
        environment.systemPackages = [ config.services.headscale.package ];
        services.headscale = {
          enable = true;
          port = hsPreferences.reverseProxy.port;
          address = if hsPreferences.reverseProxy.enable then "127.0.0.1" else "0.0.0.0";
          settings = {
            log.level = "info";
            unix_socket_permission = "0770";
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
              extra_records = (lib.optionals hpPreferences.enable [ { name = hpPreferences.reverseProxy.domain; type = "A"; value = hpPreferences.ipAddr; } ]) ++ hsPreferences.dns.records;
              nameservers = {
                split = hsPreferences.dns.nameservers;
                global = hsPreferences.dns.globalNameservers;
              };
            };

            prefixes = {
              v4 = hsPreferences.ipv4Subnet;
              v6 = hsPreferences.ipv6Subnet;
              allocation = "sequential";
            };

            oidc = lib.mkIf (piPreferences.enable && piPreferences.clientId != null) {
              issuer = "https://${piPreferences.reverseProxy.domain}";
              client_id = piPreferences.clientId;
              client_secret_path = config.sops.secrets.headscale-oidc-secret.path;
              scope = [ "openid" "profile" "email" ];
              pkce.enabled = true;
            };

            derp = {
              server = {
                enabled = lib.mkDefault true;
                region_id = 999;
                region_code = "headscale";
                region_name = "Headscale Embedded DERP";
                stun_listen_addr = "0.0.0.0:${toString hsPreferences.stunPort}";
                automatically_add_embedded_derp_region = true;
                verify_clients = true;
              };

              urls = [ "https://controlplane.tailscale.com/derpmap/default" ];
              auto_update_enabled = true;
            };
          };
        };
      };
    };
}
