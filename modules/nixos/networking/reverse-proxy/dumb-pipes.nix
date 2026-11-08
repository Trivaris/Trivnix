{
  flake.nixosModules.networking-reverse-proxy =
    { lib, config, ... }:
    let
      reverseProxyPreferences = config.host.preferences.reverseProxy;
    in
    {
      config = lib.mkIf reverseProxyPreferences.enable {
        services.nginx.streamConfig = lib.mkIf reverseProxyPreferences.dumbPipes.enable ''
          map $ssl_preread_server_name $backend {
            ${lib.concatStringsSep "\n        " (
              lib.mapAttrsToList (
                domain: upstream: "${domain} ${upstream};"
              ) reverseProxyPreferences.dumbPipes.pipes
            )}
            default local_http;
          }

          ${lib.concatStringsSep "\n      " (
            lib.mapAttrsToList (name: upstream: ''
              upstream ${name} {
                server ${upstream.address}:${toString upstream.port};
              }
            '') reverseProxyPreferences.dumbPipes.upstreams
          )}

          upstream local_http {
            server 127.0.0.1:${toString reverseProxyPreferences.dumbPipes.fallbackPort};
          }

          server {
            listen 443;
            listen [::]:443;
            ssl_preread on;
            proxy_pass $backend;
          }

          ${lib.concatStringsSep "\n      " (
            lib.mapAttrsToList (name: fwd: ''
              server {
                ${lib.optionalString fwd.enableTCP "listen ${toString fwd.listenPort};"}
                ${lib.optionalString fwd.enableTCP "listen [::]:${toString fwd.listenPort};"}
                ${lib.optionalString fwd.enableUDP "listen ${toString fwd.listenPort} udp;"}
                ${lib.optionalString fwd.enableUDP "listen [::]:${toString fwd.listenPort} udp;"}
                proxy_pass ${fwd.upstream};
              }
            '') reverseProxyPreferences.dumbPipes.portForwards
          )}
        '';
      };
    };
}
