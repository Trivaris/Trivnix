{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.steam.enable = mkEnableOption ''
    Install Steam with bundled compatibility tooling on this host.
    Toggle this when the machine should support gaming workloads.
  '';

  config = mkIf prefs.steam.enable {
    programs.steam = {
      enable = true;
      enableMillennium = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };
}
