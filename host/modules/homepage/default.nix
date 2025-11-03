{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  imports = [
    (lib.mkAliasOptionModule
      [ "hostPrefs" "homepage" "settings" ]
      [ "services" "homepage-dashboard" "settings" ]
    )
    (lib.mkAliasOptionModule
      [ "hostPrefs" "homepage" "widgets" ]
      [ "services" "homepage-dashboard" "widgets" ]
    )
  ];

  config = lib.mkIf prefs.homepage.enable {
    services.homepage-dashboard = {
      enable = true;
      openFirewall = !prefs.homepage.reverseProxy.enable;
      allowedHosts = prefs.homepage.reverseProxy.domain;
      listenPort = prefs.homepage.reverseProxy.port;
      services = prefs.homepage.serviceGroups;
    };
  };
}
