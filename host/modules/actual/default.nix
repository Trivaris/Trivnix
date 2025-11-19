{
  config,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf config.hostPrefs.actual.enable {
    services.actual = {
      enable = true;
      openFirewall = !prefs.actual.reverseProxy.enable;
      settings = {
        inherit (prefs.actual.reverseProxy) port;
        hostname = prefs.actual.reverseProxy.domain;
      };
    };
  };
}
