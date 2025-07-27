{ config, lib, pkgs, ... }:
let
  cfg = config.nixosConfig;
in
with lib;
{
  options.nixosConfig.steam.enable = mkEnableOption "Enable Steam";

  config = mkIf cfg.steam.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [
        gamescope
      ];
      protontricks.enable = true;
      extest.enable = true;
    };
  };
}
