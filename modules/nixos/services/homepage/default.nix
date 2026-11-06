{
  flake.nixosModules.services-homepage =
    { config, lib, ... }:
    let
      homepagePrefs = config.hostPrefs.homepage;
    in
    {
      config = lib.mkIf homepagePrefs.enable {
        services.homepage-dashboard = {
          enable = true;
          openFirewall = !homepagePrefs.reverseProxy.enable;
          allowedHosts = homepagePrefs.reverseProxy.domain;
          listenPort = homepagePrefs.reverseProxy.port;
        };
      };
    };
}
