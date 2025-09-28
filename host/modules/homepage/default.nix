{
  config,
  lib,
  pkgs,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkAliasOptionModule mkIf;
  prefs = config.hostPrefs;
in
{
  imports = [
    (mkAliasOptionModule
      [ "hostPrefs" "homepage" "settings" ]
      [ "services" "homepage-dashboard" "settings" ]
    )
    (mkAliasOptionModule
      [ "hostPrefs" "homepage" "widgets" ]
      [ "services" "homepage-dashboard" "widgets" ]
    )
  ];

  options.hostPrefs.homepage = import ./options.nix {
    inherit (config.vars) activeServices;
    inherit (lib) mkEnableOption mkOption;
    inherit (trivnixLib) mkReverseProxyOption;
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
