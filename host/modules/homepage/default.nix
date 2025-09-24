{
  lib,
  pkgs,
  config,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf mkAliasOptionModule;
  prefs = config.hostPrefs;
in
{
  imports = [
    (mkAliasOptionModule
      [ "hostPrefs" "homepage" "widgets" ]
      [ "services" "homepage-dashboard" "widgets" ]
    )
    (mkAliasOptionModule
      [ "hostPrefs" "homepage" "settings" ]
      [ "services" "homepage-dashboard" "settings" ]
    )
  ];

  options.hostPrefs.homepage = import ./options.nix {
    inherit (config.vars) activeServices;
    inherit (trivnixLib) mkReverseProxyOption;
    inherit (lib) mkEnableOption mkOption;
    inherit pkgs;
  };

  config = mkIf prefs.homepage.enable {
    services.homepage-dashboard = {
      enable = true;
      openFirewall = !prefs.homepage.reverseProxy.enable;
      allowedHosts = prefs.homepage.reverseProxy.domain;
      listenPort = prefs.homepage.reverseProxy.port;
      services = prefs.homepage.serviceGroups;
    };
  };
}
