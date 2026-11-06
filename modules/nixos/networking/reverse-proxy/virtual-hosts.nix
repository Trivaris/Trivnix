{
  flake.nixosModules.networking-reverse-proxy =
    { config, lib, ... }:
    let
      reverse-proxy-prefs = config.host-prefs.reverse-proxy;
    in
    {
      config = lib.mkIf reverse-proxy-prefs.enable {
        services.nginx.virtualHosts =
          builtins.listToAttrs (
            map (
              service:
              lib.nameValuePair service.domain {
                locations = {
                  "/" = {
                    proxyPass =
                      if service.enableAnubis then
                        "http://unix:/run/anubis/anubis-${service.name}/anubis.sock"
                      else
                        "${if service.https then "https" else "http"}://${service.address}:${toString service.port}";
                    proxyWebsockets = true;
                    extraConfig = ''
                      proxy_set_header Accept-Encoding gzip;
                    '';
                  };
                };

                forceSSL = !reverse-proxy-prefs.dumbPipes.enable;
                addSSL = reverse-proxy-prefs.dumbPipes.enable;
                useACMEHost = service.domain;

                listen = [
                  {
                    addr = if reverse-proxy-prefs.dumbPipes.enable then "127.0.0.1" else "0.0.0.0";
                    port =
                      if reverse-proxy-prefs.dumbPipes.enable then
                        reverse-proxy-prefs.dumbPipes.fallbackPort
                      else
                        service.externalPort;
                    ssl = true;
                  }
                ]
                ++ lib.optional (!reverse-proxy-prefs.dumbPipes.enable) {
                  addr = "[::]";
                  port = service.externalPort;
                  ssl = true;
                };
              }
            ) config.vars.active-services
          )
          // lib.optionalAttrs reverse-proxy-prefs.dumbPipes.enable {
            "default-http-redirect" = {
              serverName = "_";
              default = true;
              listen = [
                {
                  addr = "0.0.0.0";
                  port = 80;
                  ssl = false;
                }
                {
                  addr = "[::]";
                  port = 80;
                  ssl = false;
                }
              ];
              forceSSL = false;
              locations."/".return = "301 https://$host$request_uri";
            };
          };
      };
    };
}
