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
  options.userPrefs.enableRandomStuff = mkEnableOption "Enable other utilities, grouped in no particular order";

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
