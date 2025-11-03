{
  config,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.cfddns.enable {
    services.cfddns = {
      inherit (prefs.cfddns.reverseProxy) port;
      enable = true;
    };
  };
}
