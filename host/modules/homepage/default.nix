{ config, lib, ... }:
let
  homepagePrefs = config.hostPrefs.homepage;
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

  config = lib.mkIf homepagePrefs.enable {
    services.homepage-dashboard = {
      enable = true;
      openFirewall = !homepagePrefs.reverseProxy.enable;
      allowedHosts = homepagePrefs.reverseProxy.domain;
      listenPort = homepagePrefs.reverseProxy.port;
      services = homepagePrefs.serviceGroups;
    };
  };
}
