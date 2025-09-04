{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  prefs = config.userPrefs;
in
{
  options.userPrefs.lutris.enable = mkEnableOption "Enable Lutris Gaming";

  config = mkIf prefs.lutris.enable {
    home.packages = [
      (pkgs.lutris.override {
        extraPkgs = pkgs: [

        ];
      })
    ];
  };
}
