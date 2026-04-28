{ config, lib, ... }:
let
  reverseProxyPrefs = config.hostPrefs.reverseProxy;
in
{
  config = lib.mkIf reverseProxyPrefs.enable {
    networking.firewall.allowedTCPPorts = [
      reverseProxyPrefs.port
    ]
    ++ (map (service: service.externalPort) (
      builtins.filter (service: service.externalPort != null) config.vars.activeServices
    ));

    users.users.nginx.extraGroups = [ "acme" ];
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
