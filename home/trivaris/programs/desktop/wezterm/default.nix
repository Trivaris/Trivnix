{
  config,
  ...
}:
with config.colors;
{

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    colorSchemes.default = {
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
    extraConfig = ''
      return {
        enable_tab_bar = false,
        color_scheme = "default",
      }
    '';
  };

}
