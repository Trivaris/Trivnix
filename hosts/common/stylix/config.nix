{
  mkEnableOption,
  mkOption,
  types,
}:
{
  darkmode = mkEnableOption "Wether to enable dark mode";

  colorscheme = mkOption {
    type = types.str;
    example = "tokyo-night-dark";
    description = ''
      Name of the base16 color scheme to apply system-wide.
      This must match a file in {pkgs.base16-schemes}/share/themes/, excluding the `.yaml` extension.
    '';
  };

  cursorPackage = mkOption {
    type = types.str;
    example = "catppuccin-cursors";
    description = ''
      The name of the cursor theme package in the Nixpkgs package set.
      This will be resolved as `pkgs.<package>`.
    '';
  };

  cursorName = mkOption {
    type = types.str;
    example = "Catppuccin-Mocha-Dark-Cursors";
    description = ''
      The internal name of the cursor theme within the package.
      This must match a theme name that the package provides.
    '';
  };

  cursorSize = mkOption {
    type = types.int;
    default = 24;
    description = ''
      Size of the cursor
    '';
  };

  nerdfont = mkOption {
    type = types.str;
    example = "ubuntu";
    description = ''
      The name of the Nerd Font to use for all font categories (monospace, sansSerif, serif).
    '';
  };
}
