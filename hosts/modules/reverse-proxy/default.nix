{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.hostPrefs;

  activeServices = builtins.filter (service: service.enable or false) [
    cfg.codeServer
    cfg.nextcloud
    cfg.suwayomi
    cfg.vaultwarden
    cfg.sunshine
  ];

  externalPorts = builtins.map (service: service.externalPort) (
    builtins.filter (service: service.externalPort != null) activeServices
  );
in
{
  options.hostPrefs.reverseProxy = import ./config.nix {
    inherit (lib) mkEnableOption mkOption types;
  };

  config =
    let
      ddclient = import ./ddclient.nix { inherit cfg config activeServices; };
      acme = import ./acme.nix { inherit cfg config activeServices; };
      virtualHosts = import ./virtualHosts.nix { inherit cfg activeServices; };
    in
    mkIf (cfg.reverseProxy.enable) {
      networking.firewall.allowedTCPPorts = [ cfg.reverseProxy.port ] ++ externalPorts;
      security = { inherit acme; };

      services = {
        inherit ddclient;
        nginx = {
          inherit virtualHosts;
          package = pkgs.openresty;
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
            lua_shared_dict wol 1m;
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
