{
  flake.nixosModules.networking-pihole =
    {
      config,
      lib,
      ...
    }:
    let
      piholePreferences = config.host.preferences.pihole;
      wireguardPreferences = config.host.preferences.wireguard;
      wgIp = builtins.head (lib.splitString "/" wireguardPreferences.address);
    in
    {
      config = lib.mkIf piholePreferences.enable {
        services = {
          pihole-ftl = {
            enable = true;
            useDnsmasqConfig = true;
            settings = {
              dns.listeningMode = "bind";
              dns.upstreams = [
                "9.9.9.9"
                "149.112.112.112"
              ];

              misc.dnsmasq_lines = [
                "interface=${wireguardPreferences.interfaceName}"
                "except-interface=lo"
                "bind-interfaces"
              ];
            };
          };

          pihole-web = {
            enable = true;
            hostName = piholePreferences.reverseProxy.domain;
            ports = [
              (if piholePreferences.reverseProxy.enable then piholePreferences.reverseProxy.port else 80)
            ];
          };

          nginx = lib.mkIf piholePreferences.reverseProxy.enable {
            streamConfig = ''
              server {
                listen 853 ssl;
                proxy_pass ${wgIp}:53;

                ssl_certificate /var/lib/acme/${piholePreferences.reverseProxy.domain}/fullchain.pem;
                ssl_certificate_key /var/lib/acme/${piholePreferences.reverseProxy.domain}/key.pem;

                ssl_protocols TLSv1.2 TLSv1.3;
                ssl_ciphers HIGH:!aNULL:!MD5;
                ssl_handshake_timeout 10s;
              }
            '';
          };
        };

        networking.firewall.allowedTCPPorts = [ 853 ];
        networking.firewall.interfaces."${wireguardPreferences.interfaceName}" = {
          allowedUDPPorts = [ 53 ];
          allowedTCPPorts = [ 53 ];
        };
      };
    };
}
