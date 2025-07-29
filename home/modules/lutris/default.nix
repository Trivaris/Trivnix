{
  inputs,
  config,
  lib,
  userconfig,
  pkgs,
  ...
}:
let
  cfg = config.homeConfig;
in
with lib;
{
  options.homeConfig.lutris.enable = mkEnableOption "Enable Lutris Gaming";

  config = mkIf cfg.lutris.enable {
    home.packages = with pkgs; [
      (lutris.override {
        extraPkgs = pkgs: [

        ];
      })
    ];
  };
}