{
  config,
  pkgs,
  lib,
  isNixos,
  hostPrefs,
  trivnixLib,
  ...
}:
let
  prefs = if !isNixos then config.userPrefs else hostPrefs;
in
if !isNixos then {
  options.userPrefs.stylix = import ./config.nix { inherit (lib) mkEnableOption mkOption types; };

  config.stylix =
    let
      theme = "${pkgs.base16-schemes}/share/themes/${prefs.stylix.colorscheme}.yaml";
    in
    {
      enable = true;
      base16Scheme = theme;
      polarity = if prefs.stylix.darkmode then "dark" else "light";
      targets.gtk.enable = true;

      image =
        pkgs.runCommand "tinted-wallpaper.png"
          {
            nativeBuildInputs = builtins.attrValues { inherit (pkgs) imagemagickBig yq; };
            inherit theme;
            inputImage = trivnixLib.mkStorePath "resources/wallpaper2.png";
          }
          ''
            cp "$inputImage" wallpaper.png
            COLOR=$(yq -r '.palette.base03' "$theme")
            magick wallpaper.png -fill "$COLOR" -colorize 25% $out
          '';

      cursor = {
        package = pkgs.${prefs.stylix.cursorPackage};
        name = prefs.stylix.cursorName;
        size = prefs.stylix.cursorSize;
      };

      fonts = {
        monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };

        sansSerif = {
          name = prefs.stylix.nerdfont;
          package = pkgs.nerd-fonts.${prefs.stylix.nerdfont};
        };

        serif = config.stylix.fonts.sansSerif;
      };
    };
} else { }
