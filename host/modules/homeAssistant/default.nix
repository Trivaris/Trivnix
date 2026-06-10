{
  config,
  lib,
  ...
}:
let 
  homeAssistantPrefs = config.hostPrefs.homeAssistant;
  wireguardPrefs = config.hostPrefs.wireguard;
in 
{
  config = lib.mkIf homeAssistantPrefs.enable {
    services.home-assistant = {
      enable = true;
      openFirewall = !homeAssistantPrefs.reverseProxy.enable;
      configWritable = true;
      extraComponents = homeAssistantPrefs.extraComponents;
      config = {
        http = {
          use_x_forwarded_for = true;
          trusted_proxies = [ "127.0.0.1" "::1" ]; 
        };
      };
    };

    services.mosquitto = {
      enable = true;
      listeners = [
        {
          address = "0.0.0.0";
          settings = {
            allow_anonymous = true; 
          };
        }
      ];
    };

    networking.firewall.interfaces = lib.mkIf wireguardPrefs.enable {
      "${wireguardPrefs.interfaceName}".allowedTCPPorts = [ 1883 ];
    };
  };
}
