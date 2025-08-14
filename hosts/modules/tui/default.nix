{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hostPrefs;
in
{

  options.hostPrefs.tui.enable = mkEnableOption "Enable CLI Tools related to TUIs";

  config = mkIf cfg.tui.enable {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        nchat
        instagram-cli
        gurk-rs
        discordo
        ;
    };
  };

}
