{ config, lib, ... }:
let
  inherit (lib)
    filterAttrs
    mapAttrsToList
    mkAfter
    mkIf
    mkOption
    nameValuePair
    types
    ;

  prefs = config.hostPrefs;
  acmeUnits = map (service: "acme-${service.domain}.service") config.vars.activeServices;
in
{
  options = {
    hostPrefs.reverseProxy = import ./options.nix {
      inherit (lib) mkEnableOption mkOption types;
    };

    vars =
      let
        servicesToList = mapAttrsToList (name: service: service.reverseProxy // { inherit name; });
      in
      {
        extraCertDomains = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };

        activeServices = mkOption {
          type = types.listOf (types.attrsOf types.anything);
          default = servicesToList (
            (filterAttrs (_: pref: builtins.isAttrs pref && (pref.reverseProxy or { }).enable or false)) prefs
          );
        };
      };
  };

  config =
    let
      dependencies = { inherit config nameValuePair prefs; };
      ddclient = import ./ddclient.nix dependencies;
      acme = import ./acme.nix dependencies;
      virtualHosts = import ./virtualHosts.nix dependencies;
    in
    mkIf prefs.reverseProxy.enable {
      security = { inherit acme; };

      networking.firewall.allowedTCPPorts = [
        prefs.reverseProxy.port
      ]
      ++ (map (service: service.externalPort) (
        builtins.filter (service: service.externalPort != null) config.vars.activeServices
      ));

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
