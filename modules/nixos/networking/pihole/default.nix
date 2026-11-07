{
  flake.nixosModules.networking-pihole =
    {
      config,
      lib,
      ...
    }:
    let
      pihole-prefs = config.host-prefs.pihole;
      wireguard-prefs = config.host-prefs.wireguard;
      wgIp = builtins.head (lib.splitString "/" wireguard-prefs.address);
    in
    {
      config = lib.mkIf pihole-prefs.enable {
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
                "interface=${wireguard-prefs.interfaceName}"
                "except-interface=lo"
                "bind-interfaces"
              ];
            };
          };

          pihole-web = {
            enable = true;
            hostName = pihole-prefs.reverseProxy.domain;
            ports = [ (if pihole-prefs.reverseProxy.enable then pihole-prefs.reverseProxy.port else 80) ];
          };

          nginx = lib.mkIf pihole-prefs.reverseProxy.enable {
            streamConfig = ''
              server {
                listen 853 ssl;
                proxy_pass ${wgIp}:53;

                ssl_certificate /var/lib/acme/${pihole-prefs.reverseProxy.domain}/fullchain.pem;
                ssl_certificate_key /var/lib/acme/${pihole-prefs.reverseProxy.domain}/key.pem;

                ssl_protocols TLSv1.2 TLSv1.3;
                ssl_ciphers HIGH:!aNULL:!MD5;
                ssl_handshake_timeout 10s;
              }
            '';
          };
        };

        networking.firewall.allowedTCPPorts = [ 853 ];
        networking.firewall.interfaces."${wireguard-prefs.interfaceName}" = {
          allowedUDPPorts = [ 53 ];
          allowedTCPPorts = [ 53 ];
        };
      };
    };
}
