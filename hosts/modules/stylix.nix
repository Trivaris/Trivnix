{ config, pkgs, lib, libExtra, ... }:

let
  cfg = config.nixosConfig;
in
{
  options.nixosConfig.stylix = {
    enable = lib.mkEnableOption "Enable Stylix theming support for system appearance.";

    colorscheme = lib.mkOption {
      type = lib.types.str;
      example = "tokyo-night-dark";
      description = ''
        Name of the base16 color scheme to apply system-wide.
        This must match a file in {pkgs.base16-schemes}/share/themes/, excluding the `.yaml` extension.
      '';
    };

    cursorPackage = lib.mkOption {
      type = lib.types.str;
      example = "catppuccin-cursors";
      description = ''
        The name of the cursor theme package in the Nixpkgs package set.
        This will be resolved as `pkgs.<package>`.
      '';
    };

    cursorName = lib.mkOption {
      type = lib.types.str;
      example = "Catppuccin-Mocha-Dark-Cursors";
      description = ''
        The internal name of the cursor theme within the package.
        This must match a theme name that the package provides.
      '';
    };

    cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 24;
      description = ''
        Size of the cursor
      '';
    };

    nerdfont = lib.mkOption {
      type = lib.types.str;
      example = "JetBrainsMono";
      description = ''
        The name of the Nerd Font to use for all font categories (monospace, sansSerif, serif).
      '';
    };
  };

  config = lib.mkIf cfg.stylix.enable {
    stylix = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.stylix.colorscheme}.yaml";
      
      image = libExtra.mkFlakePath /resources/wp_1.png;
      polarity = "dark";

      cursor.package = pkgs.${cfg.stylix.cursorPackage};
      cursor.name = cfg.stylix.cursorName;
      cursor.size = cfg.stylix.cursorSize;

      # fonts =
      # let
      #   nerdFontName = "${cfg.stylix.nerdfont} Nerd Font";
      #   nerdFontPkg = pkgs.nerdfonts.override { fonts = [ cfg.stylix.nerdfont ]; };
      # in
      # {
      #   monospace = {
      #     name = nerdFontName;
      #     package = nerdFontPkg;
      #   };
      # 
      #   sansSerif = {
      #     name = nerdFontName;
      #     package = nerdFontPkg;
      #   };
      # 
      #   serif = config.stylix.fonts.sansSerif;
      # };
    };
  };
}
