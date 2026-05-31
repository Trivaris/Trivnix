{
  config,
  lib,
  ...
}:
let 
  homeAssistantPrefs = config.hostPrefs.homeAssistant;
in 
{
  config = lib.mkIf homeAssistantPrefs.enable {
    services.home-assistant = {
      enable = true;
      openFirewall = !homeAssistantPrefs.reverseProxy.enable;
      config = lib.mkIf homeAssistantPrefs.reverseProxy.enable {
        http = {
          use_x_forwarded_for = true;
          trusted_proxies = [ "127.0.0.1" ];
        };
      };
    };

    networking.firewall.allowedUDPPorts = lib.mkIf homeAssistantPrefs.wireguard.enable [ homeAssistantPrefs.wireguard.port ];

    networking.wireguard.interfaces."wg-ha" = lib.mkIf homeAssistantPrefs.wireguard.enable {
      ips = [ "10.0.0.1/24" ];
      listenPort = homeAssistantPrefs.wireguard.port;
      
      privateKeyFile = config.sops.secrets.home-assistant-wireguard-key.path;

      peers = [
        {
          publicKey = lib.removeSuffix "\n" (builtins.readFile homeAssistantPrefs.wireguard.publicKeyFile);
          allowedIPs = [ homeAssistantPrefs.wireguard.serverIp homeAssistantPrefs.wireguard.allowedSubnet ]; 
        }
      ];
    };
  };
}