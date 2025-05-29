{ 
  config, 
  lib, 
  pkgs,
  ... 
}: with config.colors; let
  weztermColorScheme = {
    name = "Material Green";
    foreground = dark.on_surface;
    background = dark.background;
    cursor_bg = dark.primary;
    cursor_border = dark.primary;
    cursor_fg = dark.on_primary;
    selection_bg = dark.surface_container_high;
    selection_fg = dark.on_surface;
    ansi = [
      dark.surface_dim
      dark.error
      dark.primary
      dark.tertiary
      dark.tertiary
      dark.secondary
      dark.tertiary_fixed_dim
      dark.on_surface_variant
    ];
    brights = [
      dark.surface_bright
      dark.error_container
      dark.primary_fixed_dim
      dark.tertiary_fixed_dim
      dark.on_tertiary
      dark.secondary_fixed_dim
      dark.on_secondary
      dark.surface_container_highest
    ];
  };

  toLuaList = list: "[" + lib.concatStringsSep ", " (map (x: ''"${x}"'') list) + "]";
in
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    extraConfig = ''
      return {
        color_schemes = {
          ["${weztermColorScheme.name}"] = {
            foreground = "${weztermColorScheme.foreground}",
            background = "${weztermColorScheme.background}",
            cursor_bg = "${weztermColorScheme.cursor_bg}",
            cursor_border = "${weztermColorScheme.cursor_border}",
            cursor_fg = "${weztermColorScheme.cursor_fg}",
            selection_bg = "${weztermColorScheme.selection_bg}",
            selection_fg = "${weztermColorScheme.selection_fg}",
            ansi = ${toLuaList weztermColorScheme.ansi},
            brights = ${toLuaList weztermColorScheme.brights},
          },
        },
        color_scheme = "${weztermColorScheme.name}",
      }
    '';
  };
}
