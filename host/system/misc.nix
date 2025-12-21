{
  allUserPrefs,
  lib,
  ...
}:
{
  networking.firewall.allowedTCPPorts = lib.mkIf (lib.any (prefs: prefs.wayvnc.enable or false) (
    builtins.attrValues allUserPrefs
  )) [ 5900 ];
}
