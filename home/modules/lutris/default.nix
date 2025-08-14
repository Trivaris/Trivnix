{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userPrefs;
in
{
  options.userPrefs.lutris.enable = mkEnableOption "Enable Lutris Gaming";

  config = mkIf cfg.lutris.enable {
    home.packages = [
      (pkgs.lutris.override {
        extraPkgs = pkgs: [

        ];
      })
    ];
  };
}
