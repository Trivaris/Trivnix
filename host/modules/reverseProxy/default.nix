{ config, lib, ... }:
let
  reverseProxyPrefs = config.hostPrefs.reverseProxy;
  allowedTCPPorts = (map (
    service: service.externalPort
  ) config.vars.activeServices) ++ lib.optionals reverseProxyPrefs.dumbPipes.enable (map (tcpForward: tcpForward.listenPort) (builtins.attrValues reverseProxyPrefs.dumbPipes.tcpForwards));
in
{
  config = lib.mkIf reverseProxyPrefs.enable {
    networking.firewall.allowedTCPPorts = allowedTCPPorts;

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
