{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    pipe
    nameValuePair
    mkAfter
    mkOption
    types
    mapAttrsToList
    filterAttrs
    ;

  prefs = config.hostPrefs;
  acmeUnits = map (service: "acme-${service.domain}.service") config.vars.activeServices;
in
{
  options = {
    hostPrefs.reverseProxy = import ./options.nix {
      inherit (lib) mkEnableOption mkOption types;
    };

    vars.activeServices = mkOption {
      type = types.listOf (types.attrsOf types.anything);
      default = pipe prefs [
        (filterAttrs (_: pref: builtins.isAttrs pref && (pref.reverseProxy or { }).enable or false))
        (mapAttrsToList (name: service: service.reverseProxy // { inherit name; }))
      ];
    };
  };

  config =
    let
      ddclient = import ./ddclient.nix {
        inherit (config.vars) activeServices;
        inherit prefs config;
      };

      acme = import ./acme.nix {
        inherit (config.vars) activeServices;
        inherit prefs config nameValuePair;
      };

      virtualHosts = import ./virtualHosts.nix {
        inherit (config.vars) activeServices;
        inherit prefs nameValuePair;
      };
    in
    mkIf prefs.reverseProxy.enable {
      networking.firewall.allowedTCPPorts = [
        prefs.reverseProxy.port
      ]
      ++ (map (service: service.externalPort) (
        builtins.filter (service: service.externalPort != null) config.vars.activeServices
      ));
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

          appendHttpConfig = mkAfter ''
            map $http_upgrade $connection_upgrade {
              default upgrade;
              \'\'      close;
            }
          '';
        };
      };

      systemd = {
        services.nginx = {
          requires = acmeUnits;
          after = acmeUnits;
        };

        timers.ddclient = mkIf (prefs.reverseProxy.ddnsTime != null && prefs.reverseProxy.enableDDClient) {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = prefs.reverseProxy.ddnsTime;
            Persistent = true;
          };
        };
      };
    };
}
