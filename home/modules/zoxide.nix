{ config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{

  options.homeConfig.zoxide = {
    enable = mkEnableOption "Extended Zoxide Configuration";
  };

  config = mkIf cfg.zoxide.enable {
    programs.zoxide = {
      enable = true;
    };
    # programs.fish.functions.cd.body = "z $argv";
  };
  
}