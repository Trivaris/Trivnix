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
            ${lib.concatStringsSep "\n    " (
              lib.mapAttrsToList (domain: upstream:
                let u = reverseProxyPreferences.dumbPipes.upstreams.${upstream};
                in "${domain} ${if u.proxyProtocol then upstream else "${upstream}_relay"};"
              ) reverseProxyPreferences.dumbPipes.pipes
            )}
            default local_http;
          }

          ${lib.concatStringsSep "\n  " (
            lib.mapAttrsToList (name: u: ''
              upstream ${name} {
                server ${u.address}:${toString u.port};
              }
            '') reverseProxyPreferences.dumbPipes.upstreams
          )}

          ${lib.concatStringsSep "\n  " (
            lib.mapAttrsToList (name: u: lib.optionalString (!u.proxyProtocol) ''
              upstream ${name}_relay {
                server 127.0.0.1:${toString u.relayPort};
              }
              server {
                listen 127.0.0.1:${toString u.relayPort} proxy_protocol;
                proxy_pass ${name};
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
            proxy_protocol on;
          }

          ${lib.concatStringsSep "\n  " (
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
