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
            ipv4Regex = ''^[0-9]{1,3}(\.[0-9]{1,3}){3}$'';
            upstreamIp =
              if builtins.match ipv4Regex service.ipAddress != null then
                service.ipAddress
              else
                throw "Reverse proxy service '${service.name}' must use an IPv4 address for hostPrefs.${service.name}.reverseProxy.ipAddress.";
          in
          {
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

            locations = {
              "/" = {
                proxyPass = "http://${upstreamIp}:${toString service.port}";
                proxyWebsockets = true;
                extraConfig = ''
                  proxy_set_header Accept-Encoding gzip;
                '';
              };
            };
          }
        )
      ) config.vars.activeServices
    );
  };
}
