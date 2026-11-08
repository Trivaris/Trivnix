{
  flake.nixosModules.services-actual =
    {
      config,
      lib,
      ...
    }:
    let
      actualPreferences = config.host.preferences.actual;
    in
    {
      config = lib.mkIf actualPreferences.enable {
        services.actual = {
          enable = true;
          openFirewall = !actualPreferences.reverseProxy.enable;
          settings = {
            inherit (actualPreferences.reverseProxy) port;
            hostname = actualPreferences.reverseProxy.domain;
          };
        };
      };
    };
}
