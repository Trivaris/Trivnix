{
  flake.nixosModules.networking-reverse-proxy =
    { config, lib, ... }:
    let
      reverseProxyPreferences = config.host.preferences.reverseProxy;
    in
    {
      config = lib.mkIf reverseProxyPreferences.enable {
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
                    ''
                    + lib.optionalString (service.allowFrom != [ ]) ''
                      ${lib.concatMapStrings (net: "allow ${net};\n") service.allowFrom}
                      deny all;
                    '';
                  };
                };

                forceSSL = !reverseProxyPreferences.dumbPipes.enable;
                addSSL = reverseProxyPreferences.dumbPipes.enable;
                useACMEHost = service.domain;

                listen = [
                  {
                    addr = if reverseProxyPreferences.dumbPipes.enable then "127.0.0.1" else "0.0.0.0";
                    port =
                      if reverseProxyPreferences.dumbPipes.enable then
                        reverseProxyPreferences.dumbPipes.fallbackPort
                      else
                        service.externalPort;
                    ssl = true;
                    proxyProtocol = reverseProxyPreferences.dumbPipes.enable;
                  }
                ]
                ++ lib.optional (!reverseProxyPreferences.dumbPipes.enable) {
                  addr = "[::]";
                  port = service.externalPort;
                  ssl = true;
                };
              }
            ) config.user.vars.activeServices
          )
          // lib.optionalAttrs reverseProxyPreferences.dumbPipes.enable {
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
