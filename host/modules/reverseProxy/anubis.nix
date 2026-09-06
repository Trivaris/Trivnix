{ config, lib, ... }:
let
  reverseProxyPrefs = config.hostPrefs.reverseProxy;
  anubisServices = builtins.filter (s: s.enableAnubis or false) config.vars.activeServices;
in
{
  config = lib.mkIf reverseProxyPrefs.enable {
    services.anubis.instances = builtins.listToAttrs (
      map (service: lib.nameValuePair service.name {
        enable = true;
        settings = {
          BIND_NETWORK = "tcp";
          BIND = "127.0.0.1:${toString reverseProxyPrefs.anubisPort}";
          TARGET = "${if service.https then "https" else "http"}://${service.address}:${toString service.port}";
          COOKIE_DOMAIN = reverseProxyPrefs.zone;
          PUBLIC_URL = "https://${service.domain}";
          DIFFICULTY = 4;
        };
      }) anubisServices
    );
  };
}