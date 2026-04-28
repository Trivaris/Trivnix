{
  lib,
  pkgs,
  config,
  ...
}:
let
  jtegranxPrefs = config.hostPrefs.jtegranx;
in
{
  options.hostPrefs.jtegranx.enable = lib.mkEnableOption "Enable jtegranx support";
  config = lib.mkIf jtegranxPrefs.enable {
    environment.systemPackages = [ pkgs.jtegranx ];
    services.udev = {
      enable = true;
      packages = [ pkgs.jtegranx ];
    };
  };
}
