{
  imports = [
    ./options.nix
  ];

  flake.nixosModules.services-actual =
    {
      config,
      lib,
      ...
    }:
    let
      actual-prefs = config.host-prefs.actual;
    in
    {
      config = lib.mkIf actual-prefs.enable {
        services.actual = {
          enable = true;
          openFirewall = !actual-prefs.reverseProxy.enable;
          settings = {
            inherit (actual-prefs.reverseProxy) port;
            hostname = actual-prefs.reverseProxy.domain;
          };
        };
      };
    };
}
