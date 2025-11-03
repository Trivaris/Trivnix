{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.reverseProxy.enable {
    networking.firewall.allowedTCPPorts = [
      prefs.reverseProxy.port
    ]
    ++ (map (service: service.externalPort) (
      builtins.filter (service: service.externalPort != null) config.vars.activeServices
    ));

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
      appendHttpConfig = lib.mkAfter ''
        map $http_upgrade $connection_upgrade {
          default upgrade;
          \'\'      close;
        }
      '';
    };
  };
}
