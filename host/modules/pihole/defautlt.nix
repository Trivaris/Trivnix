{
  config,
  lib,
  ...
}:
let
  piHolePrefs = config.hostPrefs.piHole;
  wireguardPrefs = config.hostPrefs.wireguard;
  wgIp = builtins.head (lib.splitString "/" wireguardPrefs.vpnSubnet);
in
{
  config = lib.mkIf piHolePrefs.enable {
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
            "interface=${wireguardPrefs.interfaceName}"
            "except-interface=lo"
            "bind-interfaces"
          ];
        };
      };

      pihole-web = {
        enable = true;
        hostName =  piHolePrefs.reverseProxy.domain;
        ports = [ (if piHolePrefs.reverseProxy.enable then piHolePrefs.reverseProxy.port else 80) ];
      };

      nginx = lib.mkIf piHolePrefs.reverseProxy.enable {
        streamConfig = ''
          server {
            listen 853 ssl;
            proxy_pass ${wgIp}:53;

            ssl_certificate /var/lib/acme/${piHolePrefs.reverseProxy.domain}/fullchain.pem;
            ssl_certificate_key /var/lib/acme/${piHolePrefs.reverseProxy.domain}/key.pem;

            ssl_protocols TLSv1.2 TLSv1.3;
            ssl_ciphers HIGH:!aNULL:!MD5;
            ssl_handshake_timeout 10s;
          }
        '';
      };
    };
    
    networking.firewall.interfaces."${wireguardPrefs.interfaceName}" = {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };
  };
}