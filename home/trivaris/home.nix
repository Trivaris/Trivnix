{
  config,
  lib,
  pkgs,
  ...
}:
{

  home.username = lib.mkDefault "trivaris";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.sessionVariables.SHELL = "${pkgs.fish}/bin/fish";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    coreutils
    httpie
    fd
    btop
    procs
    ripgrep
    tldr
    zip
    bat
    fastfetch
    rofi
    pipes-rs
    rsclock

    #r-matrix
    #rbonsai
  ];

  home.file = {

  };

  home.sessionVariables = {

  };

  programs.home-manager.enable = true;

}
