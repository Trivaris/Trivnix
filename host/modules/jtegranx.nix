{
  lib,
  pkgs,
  config,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.jtegranx.enable = lib.mkEnableOption "Enable jtegranx support";
  config = lib.mkIf prefs.jtegranx.enable {
    environment.systemPackages = [ pkgs.jtegranx ];
    services.udev = {
      enable = true;
      packages = [ pkgs.jtegranx ];
    };
  };
}
