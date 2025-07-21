{ pkgs, config, lib, ... }:
let
  cfg = config.homeModules;
in
with lib;
{

  options.homeModules.eza = {
    enable = mkEnableOption "Extended Eza Configuration";
  };

  config = mkIf cfg.eza.enable {
    programs.eza = {
      enable = true;
      extraOptions = [
        "-l"
        "--icons"
        "--git"
        "-a"
      ];
    };
  };
  
}