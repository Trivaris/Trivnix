{ config, osConfig, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
  scheme = osConfig.themingPrefs.scheme;
in
{
  programs.rofi = {
    enable = true;

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      terminal = config.vars.terminalEmulator;
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Windows";
      drun-display-format = "{name}";
    };

    theme = {
      "*" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "${scheme.base05}";
        border-color = mkLiteral "${scheme.base0E}";
      };

      window = {
        width = mkLiteral "720px";
        padding = mkLiteral "20px";
        border = mkLiteral "2px";
        border-radius = mkLiteral "12px";
        background-color = mkLiteral "${scheme.base00}";
      };

      mainbox = {
        spacing = mkLiteral "16px";
        children = mkLiteral "[ inputbar, listview ]";
      };

      inputbar = {
        children = mkLiteral "[ prompt, entry ]";
        spacing = mkLiteral "12px";
        text-color = mkLiteral "${scheme.base05}";
      };

      prompt = {
        padding = mkLiteral "10px 14px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "${scheme.base0D}";
        text-color = mkLiteral "${scheme.base00}";
      };

      entry = {
        padding = mkLiteral "10px 14px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "${scheme.base01}";
        text-color = mkLiteral "${scheme.base05}";
        placeholder = "Search…";
        placeholder-color = mkLiteral "${scheme.base03}";
      };

      listview = {
        columns = 1;
        lines = 8;
        spacing = mkLiteral "4px";
        cycle = true;
        dynamic = true;
        scrollbar = false;
        fixed-height = false;
        padding = mkLiteral "8px 0px 0px 0px";
      };

      element = {
        padding = mkLiteral "10px 14px";
        spacing = mkLiteral "12px";
        border-radius = mkLiteral "10px";
        text-color = mkLiteral "${scheme.base05}";
        cursor = mkLiteral "pointer";
      };

      "element normal.normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "${scheme.base05}";
      };

      "element selected.normal" = {
        background-color = mkLiteral "${scheme.base02}";
        text-color = mkLiteral "${scheme.base0D}";
        border = mkLiteral "1px";
        border-color = mkLiteral "${scheme.base0D}";
      };
      
      element-icon = {
        size = mkLiteral "24px";
        cursor = mkLiteral "inherit";
      };

      element-text = {
        vertical-align = mkLiteral "0.5";
        cursor = mkLiteral "inherit";
        highlight = mkLiteral "bold ${scheme.base0A}";
      };
    };
  };
}