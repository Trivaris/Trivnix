{
  config,
  pkgs,
  lib,
  libExtra,
  ...
}:
let
  cfg = config.hostPrefs;
in
{
  options.hostPrefs.stylix = import ./config.nix { inherit (lib) mkEnableOption mkOption types; };

  config.stylix =
    let
      theme = "${pkgs.base16-schemes}/share/themes/${cfg.stylix.colorscheme}.yaml";
    in
    {
      enable = true;
      base16Scheme = theme;
      polarity = if cfg.stylix.darkmode then "dark" else "light";

      image =
        pkgs.runCommand "tinted-wallpaper.png"
          {
            nativeBuildInputs = builtins.attrValues { inherit (pkgs) imagemagickBig yq; };
            inherit theme;
            inputImage = libExtra.mkFlakePath /resources/wallpaper2.png;
          }
          ''
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
