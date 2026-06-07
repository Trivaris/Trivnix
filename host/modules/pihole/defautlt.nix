{
  config,
  lib,
  ...
}:
let
  piHolePrefs = config.hostPrefs.piHole;
  wireguardPrefs = config.hostPrefs.wireguard;
in
{
  config = lib.mkIf piHolePrefs.enable {
    services = {
      pihole-ftl = {
        enable = true;
        settings = {
          dns.listeningMode = "all";
          dns.interface = wireguardPrefs.interfaceName;
          dns.upstreams = [
            "9.9.9.9"
            "149.112.112.112"
          ];
        };
      };

      pihole-web = {
        enable = true;
        hostName =  piHolePrefs.reverseProxy.domain;
        ports = [ (if piHolePrefs.reverseProxy.enable then piHolePrefs.reverseProxy.port else 80) ];
      };
    };
    
    networking.firewall.interfaces."${wireguardPrefs.interfaceName}" = {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };
  };
}