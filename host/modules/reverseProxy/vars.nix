{ lib, config, ... }:
let
  prefs = config.hostPrefs;
  servicesToList = lib.mapAttrsToList (name: service: service.reverseProxy // { inherit name; });
  isService = pref: builtins.isAttrs pref && (pref.reverseProxy or { }).enable or false;
in
{
  options.vars.activeServices = lib.mkOption {
    type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
    readOnly = true;
    default = servicesToList ((lib.filterAttrs (_: pref: isService pref)) prefs);
  };
}
