{ config, pkgs, lib, libExtra, ... }:
let
  cfg = config.nixosConfig;
in
{
  options.nixosConfig.stylix = import ./config.nix lib;

  config = lib.mkIf (cfg.stylix.enable) {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.stylix.colorscheme}.yaml";
      
      image = libExtra.mkFlakePath /resources/wallpaper.jpg;
      polarity = "dark";

      cursor.package = pkgs.${cfg.stylix.cursorPackage};
      cursor.name = cfg.stylix.cursorName;
      cursor.size = cfg.stylix.cursorSize;

      fonts = {
        monospace = {
          name = cfg.stylix.nerdfont;
          package = pkgs.nerd-fonts.${cfg.stylix.nerdfont};
        };
      
        sansSerif = {
          name = cfg.stylix.nerdfont;
          package = pkgs.nerd-fonts.${cfg.stylix.nerdfont};
        };
      
        serif = config.stylix.fonts.sansSerif;
      };
    };
  };
}
