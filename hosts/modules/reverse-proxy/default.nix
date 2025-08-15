{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;

  services = builtins.filter (pref: builtins.hasAttr "reverseProxy" pref) (builtins.attrValues prefs);
  
  activeServices = map (service: service.reverseProxy) (builtins.filter (service: service.reverseProxy.enable or false) services);

  externalPorts = builtins.map (service: service.externalPort) (
    builtins.filter (service: service.externalPort != null) activeServices
  );
in
{
  options.hostPrefs.reverseProxy = import ./config.nix { inherit (lib) mkEnableOption mkOption types; };

  config =
    let
      ddclient = import ./ddclient.nix { inherit prefs config activeServices; };
      acme = import ./acme.nix { inherit prefs config activeServices; };
      virtualHosts = import ./virtualHosts.nix { inherit prefs activeServices; };
    in
    mkIf (prefs.reverseProxy.enable) {
      networking.firewall.allowedTCPPorts = [ prefs.reverseProxy.port ] ++ externalPorts;
      security = { inherit acme; };

      services = {
        inherit ddclient;
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
            lua_shared_dict wol 1m;
          '';
        };
      };

      systemd.timers.ddclient = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = prefs.reverseProxy.ddnsTime;
          Persistent = true;
        };
      };
    };
}
