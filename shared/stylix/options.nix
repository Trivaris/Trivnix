{
  mkEnableOption,
  mkOption,
  types,
}:
{
  darkmode = mkEnableOption ''
    Enable the dark Stylix palette for this system.
    When true, Stylix renders themes using the dark color variant.
  '';

  colorscheme = mkOption {
    type = types.str;
    example = "tokyo-night-dark";
    description = ''
      Base16 color scheme name applied across Stylix-managed themes.
      Provide the scheme filename without `.yaml`; it decides the palette source.
    '';
  };

  cursorPackage = mkOption {
    type = types.str;
    example = "catppuccin-cursors";
    description = ''
      Package attribute providing the cursor theme pulled in by Stylix.
      It is looked up under `pkgs.<name>` when building your configuration.
    '';
  };

  cursorName = mkOption {
    type = types.str;
    example = "Catppuccin-Mocha-Dark-Cursors";
    description = ''
      Internal theme name Stylix selects from the chosen cursor package.
      Match it to one of the themes exposed by the package to avoid build errors.
    '';
  };

  cursorSize = mkOption {
    type = types.int;
    default = 24;
    description = ''
      Pixel size for the cursor when Stylix applies the theme.
      Impacts pointer scaling across X11 and Wayland desktops.
    '';
  };

  nerdfont = mkOption {
    type = types.str;
    example = "ubuntu";
    description = ''
      Nerd Font base name used for monospace, sans-serif, and serif fonts.
      Stylix resolves this to `pkgs.nerdfonts.<name>` when rendering fonts.
    '';
  };
}
