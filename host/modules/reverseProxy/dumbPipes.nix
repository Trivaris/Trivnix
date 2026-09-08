{ lib, config, ... }:
let
  reverseProxyPrefs = config.hostPrefs.reverseProxy;
in
{
  config = lib.mkIf reverseProxyPrefs.enable {
    services.nginx.streamConfig = lib.mkIf reverseProxyPrefs.dumbPipes.enable ''
      map $ssl_preread_server_name $backend {
        ${lib.concatStringsSep "\n        " (
          lib.mapAttrsToList (domain: upstream: "${domain} ${upstream};") reverseProxyPrefs.dumbPipes.pipes
        )}
        default local_http;
      }

      ${lib.concatStringsSep "\n      " (
        lib.mapAttrsToList (name: upstream: ''
          upstream ${name} {
            server ${upstream.address}:${toString upstream.port};
          }
        '') reverseProxyPrefs.dumbPipes.upstreams
      )}

      upstream local_http {
        server 127.0.0.1:${toString reverseProxyPrefs.dumbPipes.fallbackPort};
      }

      server {
        listen 443;
        listen [::]:443;
        ssl_preread on;
        proxy_pass $backend;
      }
    '';
  };
}