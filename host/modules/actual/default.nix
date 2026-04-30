{
  config,
  lib,
  ...
}:
let
  actualPrefs = config.hostPrefs.actual;
in
{
  config = lib.mkIf actualPrefs.enable {
    services.actual = {
      enable = true;
      openFirewall = !actualPrefs.reverseProxy.enable;
      settings = {
        inherit (actualPrefs.reverseProxy) port;
        hostname = actualPrefs.reverseProxy.domain;
      };
    };
  };
}
