{ config, lib, ... }:
let
  cfg = config.homeModules;
in
with lib;
{
  options.homeModules.rofi = mkEnableOption "rofi";

  config = mkIf cfg.rofi {
    programs.rofi = {
      enable = true;
      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
          colors = config.colors;
        in
        {
          "*" = {
            font = "FiraCode Nerd Font 12";
            background-color = mkLiteral colors.bg0;
            foreground-color = mkLiteral colors.fg;
            spacing = 2;
            border = 0;
          };

          "window" = {
            padding = 12;
            border = 2;
            border-color = mkLiteral colors.green;
            background-color = mkLiteral colors.bg1;
          };

          "#listview" = {
            scrollbar = false;
            lines = 10;
            fixed-height = false;
          };

          "#element" = {
            padding = "4 8";
            background-color = mkLiteral colors.bg2;
            text-color = mkLiteral colors.fg;
          };

          "#element selected" = {
            background-color = mkLiteral colors.bg_blue;
            text-color = mkLiteral colors.fg;
          };
        };
    };
  };

}
