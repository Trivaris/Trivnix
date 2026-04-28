{
  config,
  lib,
  ...
}:
let
  cfddnsPrefs = config.hostPrefs.cfddns;
in
{
  config = lib.mkIf cfddnsPrefs.enable {
    services.cfddns = {
      inherit (cfddnsPrefs.reverseProxy) port;
      enable = true;
    };
  };
}
