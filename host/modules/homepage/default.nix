{
  lib,
  pkgs,
  config,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.homepage = import ./options.nix {
    inherit (config.vars) activeServices;
    inherit (trivnixLib) mkReverseProxyOption;
    inherit (lib) mkEnableOption mkOption;
    inherit pkgs;
  };

  config = mkIf prefs.homepage.enable {
    services.homepage-dashboard = {
      enable = true;
      openFirewall = true;
      allowedHosts = prefs.homepage.reverseProxy.domain;
      listenPort = prefs.homepage.reverseProxy.port;
      services = prefs.homepage.serviceGroups;
    };
  };
}
