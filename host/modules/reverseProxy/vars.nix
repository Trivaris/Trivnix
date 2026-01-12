{ lib, config, ... }:
let
  prefs = config.hostPrefs;
in
{
  options.vars =
    let
      servicesToList = lib.mapAttrsToList (name: service: service.reverseProxy // { inherit name; });
    in
    {
      extraCertDomains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };

      activeServices = lib.mkOption {
        type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
        default = servicesToList (
          (lib.filterAttrs (_: pref: builtins.isAttrs pref && (pref.reverseProxy or { }).enable or false))
            prefs
        );
      };
    };
}
