{
  flake.nixosModules.networking-reverse-proxy =
    { config, lib, ... }:
    let
      reverseProxyPreferences = config.host.preferences.reverseProxy;
      anubisServices = builtins.filter (
        service: service.enableAnubis or false
      ) config.vars.activeServices;
    in
    {
      config = lib.mkIf reverseProxyPreferences.enable {
        services.anubis.instances = builtins.listToAttrs (
          map (
            service:
            lib.nameValuePair service.name {
              enable = true;
              settings = {
                BIND_NETWORK = "unix";
                BIND = "/run/anubis/anubis-${service.name}/anubis.sock";
                TARGET = "${
                  if service.https then "https" else "http"
                }://${service.address}:${toString service.port}";
                COOKIE_DOMAIN = reverseProxyPreferences.zone;
                PUBLIC_URL = "https://${service.domain}";
                DIFFICULTY = 4;
              };
            }
          ) anubisServices
        );
      };
    };
}
