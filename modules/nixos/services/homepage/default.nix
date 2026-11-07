{
  flake.nixosModules.services-homepage =
    { config, lib, ... }:
    let
      homepage-prefs = config.host-prefs.homepage;
    in
    {
      config = lib.mkIf homepage-prefs.enable {
        services.homepage-dashboard = {
          enable = true;
          openFirewall = !homepage-prefs.reverseProxy.enable;
          allowedHosts = homepage-prefs.reverseProxy.domain;
          listenPort = homepage-prefs.reverseProxy.port;
        };
      };
    };
}
