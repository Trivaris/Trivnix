{ config, ... }:
with config.colors;
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{

  programs.rofi = {
    enable = true;
    theme = {
      "*" = {
        "font" = "FiraCode Nerd Font 12";
        "background-color" = mkLiteral dark.background;
        "foreground-color" = mkLiteral dark.on_background;
        "spacing" = 2;
        "border" = 0;
      };

      "window" = {
        "padding" = 12;
        "border" = 2;
        "border-color" = mkLiteral dark.primary;
        "background-color" = mkLiteral dark.surface_container;
      };

      "#listview" = {
        "scrollbar" = false;
        "lines" = 10;
        "fixed-height" = false;
      };

      "#element" = {
        "padding" = "4 8";
        "background-color" = mkLiteral dark.surface;
        "text-color" = mkLiteral light.on_surface;
      };

      "#element selected" = {
        "background-color" = mkLiteral dark.primary_container;
        "text-color" = mkLiteral light.on_primary_container;
      };
    };
  };

}
