{ config, lib, ... }:
let
  reverseProxyPrefs = config.hostPrefs.reverseProxy;
in
{
  config = lib.mkIf reverseProxyPrefs.enable {
    services.nginx.virtualHosts = builtins.listToAttrs (
      map (
        service:
        lib.nameValuePair service.domain (
          let
            listenPort = if service.externalPort != null then service.externalPort else reverseProxyPrefs.port;
          in
          {
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:${toString service.port}";
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
                port = listenPort;
                ssl = true;
              }
              {
                addr = "[::]";
                port = listenPort;
                ssl = true;
              }
            ];

          }
        )
      ) config.vars.activeServices
    );
  };
}
