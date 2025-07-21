{ pkgs, config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{

  options.homeConfig.eza = {
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
    programs.fish.functions.ls.body = "eza $argv";
  };
  
}