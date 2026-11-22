{
  flake.nixosModules.networking-headscale =
    { lib, config, ... }:
    let
      hsPreferences = config.host.preferences.headscale;
      oicdPreferences = config.host.preferences.oicd;
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
              extra_records = hsPreferences.dns.records;
              nameservers = {
                split = hsPreferences.dns.nameservers;
                global = [
                  "1.1.1.1"
                  "9.9.9.9"
                ];
              };
            };

            prefixes = {
              v4 = "100.64.0.0/10";
              v6 = "fd7a:115c:a1e0::/48";
              allocation = "sequential";
            };

            oidc = lib.mkIf (oicdPreferences.enable && oicdPreferences.clientId != null) {
              issuer = "https://${oicdPreferences.reverseProxy.domain}";
              client_id = oicdPreferences.clientId;
              client_secret_path = config.sops.secrets.headscale-oidc-secret.path;
              scope = [ "openid" "profile" "email" ];
              pkce.enabled = true;
              # allowed_users = [ "you@example.com" ];
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
