{
  flake.nixosModules.services-homepage =
    { config, lib, ... }:
    let
      homepagePreferences = config.host.preferences.homepage;
    in
    {
      config = lib.mkIf homepagePreferences.enable {
        services.homepage-dashboard = {
          enable = true;
          openFirewall = !homepagePreferences.reverseProxy.enable;
          allowedHosts = homepagePreferences.reverseProxy.domain;
          listenPort = homepagePreferences.reverseProxy.port;
        };
      };
    };
}
