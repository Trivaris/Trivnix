{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.homeModules;
in
with lib;
{

  options.homeModules.cli-utils = mkEnableOption "cli tools";

  config = mkIf cfg.cli-utils {

    home.packages = with pkgs; [
      procs
      btop
      fastfetch
      pipes-rs
      rsclock
      rmatrix
      rbonsai
    ];

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      extraOptions = [
        "-l"
        "--icons"
        "--git"
        "-a"
      ];
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

  };

}
