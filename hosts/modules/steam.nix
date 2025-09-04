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
  options.hostPrefs.steam.enable = mkEnableOption "Enable Steam";

  config = mkIf prefs.steam.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam-millennium;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      extraPackages = [ pkgs.gamescope ];
      protontricks.enable = true;
      extest.enable = true;
    };
  };
}
