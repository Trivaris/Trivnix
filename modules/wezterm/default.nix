{ config, lib, ... }:
let
  cfg = config.modules;
in
with lib;
{

  options.modules.wezterm = mkEnableOption "wezterm";
  config = mkIf cfg.wezterm {
    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

      colorSchemes.default =
      let 
        colors = config.colors;
      in
      {
        foreground = colors.fg;
        background = colors.bg0;

        cursor_bg = colors.green;
        cursor_fg = colors.bg0;
        cursor_border = colors.green;

        selection_fg = colors.bg0;
        selection_bg = "#fffacd";

        scrollbar_thumb = "#222222";
        split = "#444444";

        ansi = [
          colors.bg0        # black
          colors.red        # maroon
          colors.green      # green
          colors.yellow     # olive
          colors.bg_blue    # navy
          colors.purple     # purple
          colors.aqua       # teal
          colors.fg         # silver
        ];

        brights = [
          colors.gray0      # grey
          colors.red        # red
          "#32CD32"         # lime (not in palette, so using limegreen)
          colors.yellow     # yellow
          colors.blue       # blue
          colors.purple     # fuchsia
          colors.aqua       # aqua
          "#ffffff"         # white
        ];

        indexed = {
          "136" = "#af8700";
        };

        compose_cursor = colors.orange;

        copy_mode_active_highlight_bg = { Color = "#000000"; };
        copy_mode_active_highlight_fg = { AnsiColor = "Black"; };
        copy_mode_inactive_highlight_bg = { Color = colors.green; };
        copy_mode_inactive_highlight_fg = { AnsiColor = "White"; };

        quick_select_label_bg = { Color = "peru"; };
        quick_select_label_fg = { Color = "#ffffff"; };
        quick_select_match_bg = { AnsiColor = "Navy"; };
        quick_select_match_fg = { Color = "#ffffff"; };

        input_selector_label_bg = { AnsiColor = "Black"; };
        input_selector_label_fg = { Color = "#ffffff"; };

        launcher_label_bg = { AnsiColor = "Black"; };
        launcher_label_fg = { Color = "#ffffff"; };
      };
      extraConfig = ''
        
              return {
                enable_tab_bar = false,
                color_scheme = "default",
              }
      '';
    };
  };

}
