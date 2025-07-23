{ config, lib, ... }:
let
  cfg = config.nixosConfig;

  activeServices =
    builtins.filter (
      service: service.enable or false
    ) [
      cfg.codeServer
      cfg.nextcloud
      cfg.suwayomi
      cfg.vaultwarden
    ];

  externalPorts = builtins.map (service: service.externalPort) (
    builtins.filter (service: service.externalPort != null) activeServices
  );
in
with lib;
{
  options.nixosConfig.reverseProxy = import ./config.nix lib;

  config = 
  let
    ddclient = import ./ddclient.nix { inherit cfg config activeServices; };
    acme = import ./acme.nix { inherit cfg config activeServices; };
    virtualHosts = import ./virtualHosts.nix { inherit cfg activeServices; };
  in
  mkIf (cfg.reverseProxy.enable) {
    networking.firewall.allowedTCPPorts =
      [ cfg.reverseProxy.port ] ++ externalPorts;
    
    security = { inherit acme; };

    services = {
      inherit ddclient;
      nginx = {        
        enable = true;
        inherit virtualHosts;

        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

        appendHttpConfig = ''
          map $http_upgrade $connection_upgrade {
            default upgrade;
            \'\'      close;
          }
        '';
      };
    };

    systemd.timers.ddclient = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.reverseProxy.ddnsTime;
        Persistent = true;
      };
    };
  };
}
