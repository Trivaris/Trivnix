{ config, pkgs, lib, libExtra, userconfigs, ... }:
let
  cfg = config.nixosConfig;
in
{
  options.nixosConfig.stylix = import ./config.nix lib;

  config.stylix = rec {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.stylix.colorscheme}.yaml";
    polarity = if cfg.stylix.darkmode then "dark" else "light";
    
    image = pkgs.runCommand "tinted-wallpaper.png" {
      nativeBuildInputs = with pkgs; [ imagemagickBig yq ];
      theme = base16Scheme;
      inputImage = libExtra.mkFlakePath /resources/wallpaper2.png;
    } ''
      cp "$inputImage" wallpaper.png
      COLOR=$(yq -r '.palette.base03' "$theme")
      magick wallpaper.png -fill "$COLOR" -colorize 25% $out
    '';

    cursor.package = pkgs.${cfg.stylix.cursorPackage};
    cursor.name = cfg.stylix.cursorName;
    cursor.size = cfg.stylix.cursorSize;

    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
    
      sansSerif = {
        name = cfg.stylix.nerdfont;
        package = pkgs.nerd-fonts.${cfg.stylix.nerdfont};
      };
    
      serif = config.stylix.fonts.sansSerif;
    };

    targets.gtk.enable = true;
  };
}
