{
  prefs,
  pkgs,
  config,
  ...
}:
let
  theme = "${pkgs.base16-schemes}/share/themes/${prefs.stylix.colorscheme}.yaml";
in
{
  enable = true;
  base16Scheme = theme;
  polarity = if prefs.stylix.darkmode then "dark" else "light";
  targets.gtk.enable = true;

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
}
