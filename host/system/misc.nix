{
  config,
  lib,
  ...
}:
let
  allUserPrefs = builtins.attrValues (builtins.mapAttrs (_: cfg: cfg.userPrefs) config.home-manager.users);
in
{
  networking.firewall.allowedTCPPorts = lib.mkIf (lib.any (prefs: prefs.wayvnc.enable or false) allUserPrefs) [ 5900 ];
}
