{ config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{

  options.homeConfig.wezterm.enable = mkEnableOption "wezterm";
  config = mkIf cfg.wezterm.enable {
    programs.wezterm = {
      enable = true;
    };
  };

}
