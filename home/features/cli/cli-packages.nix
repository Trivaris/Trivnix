{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.features.cli.cli-tools;
in {

  options.features.cli.cli-tools.enable = mkEnableOption "basic cli tools and replacements";

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      coreutils
      httpie
      fd
      btop
      procs
      ripgrep
      tldr
      zip
      r-matrix
      pipes-rs
      rbonsai
      rsclock
    ];

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      extraOptions = [ "-l" "--icons" "--git" "-a" ];
    };

    programs.bat = {
      enable = true;
    };

    programs.fastfetch = {
      enable = true;
    };
    
  };

}