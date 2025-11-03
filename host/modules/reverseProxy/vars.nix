{ lib, config, ... }:
let
  inherit (lib) types;
  prefs = config.hostPrefs;
in
{
  options.vars =
    let
      servicesToList = lib.mapAttrsToList (name: service: service.reverseProxy // { inherit name; });
    in
    {
      extraCertDomains = lib.mkOption {
        type = types.listOf types.str;
        default = [ ];
      };

      activeServices = lib.mkOption {
        type = types.listOf (types.attrsOf types.anything);
        default = servicesToList (
          (lib.filterAttrs (_: pref: builtins.isAttrs pref && (pref.reverseProxy or { }).enable or false))
            prefs
        );
      };
    };
}
