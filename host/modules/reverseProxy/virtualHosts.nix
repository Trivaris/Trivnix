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
              proxyPass = if service.enableAnubis then
                "http://unix:/run/anubis/anubis-${service.name}/anubis.sock" else
                "${if service.https then "https" else "http"}://${service.address}:${toString service.port}";
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
              addr = if reverseProxyPrefs.dumbPipes.enable then "127.0.0.1" else "0.0.0.0";
              port = if reverseProxyPrefs.dumbPipes.enable then reverseProxyPrefs.dumbPipes.fallbackPort else service.externalPort;
              ssl = true;
            }
          ] ++ lib.optional (!reverseProxyPrefs.dumbPipes.enable) {
            addr = "[::]";
            port = service.externalPort;
            ssl = true;
          };
        }
      ) config.vars.activeServices
    );
  };
}
