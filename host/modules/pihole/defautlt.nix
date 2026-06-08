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
        upstreams."pihole_backend".servers = {
          "${wgIp}:53" = {};
        };

        virtualHosts."pihole_dot" = {
          listen = [ "853 ssl" ];
          proxyPass = "pihole_backend";

          sslCertificate = "/var/lib/acme/${piHolePrefs.reverseProxy.domain}/fullchain.pem";
          sslCertificateKey = "/var/lib/acme/${piHolePrefs.reverseProxy.domain}/key.pem";

          extraConfig = ''
            ssl_protocols TLSv1.2 TLSv1.3;
            ssl_ciphers HIGH:!aNULL:!MD5;
            ssl_handshake_timeout 10s;
            ssl_session_cache shared:SSL:10m;
            ssl_session_timeout 3h;
          '';
        };
      };
    };
    
    networking.firewall.interfaces."${wireguardPrefs.interfaceName}" = {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };
  };
}