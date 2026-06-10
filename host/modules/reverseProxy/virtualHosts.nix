{ config, lib, ... }:
let
  reverseProxyPrefs = config.hostPrefs.reverseProxy;
in
{
  config = lib.mkIf reverseProxyPrefs.enable {
    services.nginx.virtualHosts = builtins.listToAttrs (
      map (
        service:
        lib.nameValuePair service.domain {
          locations = {
            "/" = {
              proxyPass = "http://${service.address}:${toString service.port}";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_set_header Accept-Encoding gzip;
              '';
            };
          };
          forceSSL = true;
          useACMEHost = service.domain;

          listen = [
            {
              addr = "0.0.0.0";
              port = service.externalPort;
              ssl = true;
            }
            {
              addr = "[::]";
              port = service.externalPort;
              ssl = true;
            }
          ];
        }
      ) config.vars.activeServices
    );
  };
}
