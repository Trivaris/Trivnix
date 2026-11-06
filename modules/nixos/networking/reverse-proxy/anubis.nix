{
  flake.nixosModules.networking-reverse-proxy =
    { config, lib, ... }:
    let
      reverse-proxy-prefs = config.host-prefs.reverse-proxy;
      anubisServices = builtins.filter (
        service: service.enableAnubis or false
      ) config.vars.active-services;
    in
    {
      config = lib.mkIf reverse-proxy-prefs.enable {
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
                COOKIE_DOMAIN = reverse-proxy-prefs.zone;
                PUBLIC_URL = "https://${service.domain}";
                DIFFICULTY = 4;
              };
            }
          ) anubisServices
        );
      };
    };
}
