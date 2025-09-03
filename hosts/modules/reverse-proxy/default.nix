{ config, lib, ... }:
let
  inherit (lib) mkIf nameValuePair;
  prefs = config.hostPrefs;

  services = builtins.filter (pref: builtins.hasAttr "reverseProxy" pref) (
    builtins.filter (pref: builtins.isAttrs pref) (builtins.attrValues prefs)
  );

  activeServices = map (service: service.reverseProxy) (
    builtins.filter (service: service.reverseProxy.enable or false) services
  );

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
      ddclient = import ./ddclient.nix { inherit prefs config activeServices; };
      acme = import ./acme.nix {
        inherit
          prefs
          config
          activeServices
          nameValuePair
          ;
      };
      virtualHosts = import ./virtualHosts.nix { inherit prefs activeServices nameValuePair; };
    in
    mkIf (prefs.reverseProxy.enable) {
      networking.firewall.allowedTCPPorts = [ prefs.reverseProxy.port ] ++ externalPorts;
      security = { inherit acme; };

      services = {
        ddclient = mkIf prefs.reverseProxy.enableDDClient ddclient;
        nginx = {
          inherit virtualHosts;
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

      systemd.timers.ddclient =
        mkIf (prefs.reverseProxy.ddnsTime != null && prefs.reverseProxy.enableDDClient)
          {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = prefs.reverseProxy.ddnsTime;
              Persistent = true;
            };
          };
    };
}
