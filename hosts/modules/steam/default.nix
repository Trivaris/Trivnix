{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hostprefs;
in
{
  options.hostprefs.steam.enable = mkEnableOption "Enable Steam";

  config = mkIf cfg.steam.enable {
    programs.steam = {
      enable = true;
      # package = pkgs.millennium;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      extraPackages = [ pkgs.gamescope ];
      protontricks.enable = true;
      extest.enable = true;
    };
  };
}
