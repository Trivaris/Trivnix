{ config, lib, ... }:
let
  reverseProxyPrefs = config.hostPrefs.reverseProxy;
  anubisServices = builtins.filter (service: service.enableAnubis or false) config.vars.activeServices;
in
{
  config = lib.mkIf reverseProxyPrefs.enable {
    services.anubis.instances = builtins.listToAttrs (
      map (service: lib.nameValuePair service.name {
        enable = true;
        settings = {
          BIND_NETWORK = "unix";
          BIND = "/run/anubis/anubis-${service.name}/anubis.sock";
          TARGET = "${if service.https then "https" else "http"}://${service.address}:${toString service.port}";
          COOKIE_DOMAIN = reverseProxyPrefs.zone;
          PUBLIC_URL = "https://${service.domain}";
          DIFFICULTY = 4;
        };
      }) anubisServices
    );
  };
}