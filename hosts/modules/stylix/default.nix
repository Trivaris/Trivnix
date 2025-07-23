{ config, pkgs, lib, libExtra, ... }:
let
  cfg = config.nixosConfig;
in
{
  options.nixosConfig.stylix = import ./config.nix lib;

  config = lib.mkIf (cfg.stylix.enable) {
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
