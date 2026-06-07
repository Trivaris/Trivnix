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
      configWritable = true;
      extraComponents = homeAssistantPrefs.extraComponents;
      # config = {
      #   http = {
      #     use_x_forwarded_for = true;
      #     trusted_proxies = [ "127.0.0.1" ];
      #     server_port = homeAssistantPrefs.reverseProxy.port;
      #     server_host =
      #       [ "127.0.0.1" ]
      #       ++ (lib.optionals homeAssistantPrefs.wireguard.enable [ "10.0.0.1" ]);
      #   };
      # };
    };
  };
}
