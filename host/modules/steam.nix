{
  config,
  lib,
  pkgs,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.steam.enable = lib.mkEnableOption ''
    Install Steam with bundled compatibility tooling on this host.
    Toggle this when the machine should support gaming workloads.
  '';

  config = lib.mkIf prefs.steam.enable {
    programs.steam = {
      enable = true;
      package = pkgs.millennium-steam;
      protontricks.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };
}
