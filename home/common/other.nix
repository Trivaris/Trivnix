{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  prefs = config.userPrefs;
in
{
  options.userPrefs.enableRandomStuff = mkEnableOption ''
    Pull in a grab bag of miscellaneous desktop utilities.
    Enable this when you want the curated extras listed in this module.
  '';

  config = mkIf prefs.enableRandomStuff {
    home.packages = builtins.attrValues {
      inherit (pkgs.kdePackages)
        kcalc
        dolphin
        ark
        gwenview
        ;

      inherit (pkgs)
        android-tools
        rsclock
        pipes-rs
        rmatrix
        rbonsai
        adbautoplayer
        me3
        hardinfo2
        protonvpn-gui
        vlc
        wayland-utils
        wl-clipboard-rs
        ;
    };
  };
}
