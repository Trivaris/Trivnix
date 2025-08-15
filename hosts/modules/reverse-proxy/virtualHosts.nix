{ prefs, activeServices }:
builtins.listToAttrs (map (service: {
  name = service.domain;
  value = {
    forceSSL = true;
    useACMEHost = service.domain;

    listen = [{
      addr = "0.0.0.0";
      port = if service.externalPort != null
             then service.externalPort
             else prefs.reverseProxy.port;
      ssl = true;
    }];

    locations = {
        "/" = {
          proxyPass = "http://${service.ipAddress}:${toString service.port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Accept-Encoding gzip;
          '';
        };
      };
  };
}) activeServices)
