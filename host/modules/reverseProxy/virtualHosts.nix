{
  activeServices,
  nameValuePair,
  prefs,
}:
builtins.listToAttrs (
  map (
    service:
    nameValuePair service.domain (
      let
        listenPort = if service.externalPort != null then service.externalPort else prefs.reverseProxy.port;
        ipv4Regex = ''^[0-9]{1,3}(\.[0-9]{1,3}){3}$'';
        upstreamIp =
          if builtins.match ipv4Regex service.ipAddress != null then
            service.ipAddress
          else
            builtins.throw "Reverse proxy service '${service.name}' must use an IPv4 address for hostPrefs.${service.name}.reverseProxy.ipAddress.";
      in
      {
        forceSSL = true;
        useACMEHost = service.domain;

        listen = [
          {
            addr = "[::]";
            port = listenPort;
            ssl = true;
            extraParameters = [ "ipv6only=off" ];
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
  ) activeServices
)
