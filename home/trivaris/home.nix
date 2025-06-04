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

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    procs
    btop
    fastfetch
    pipes-rs
    rsclock
  ];

  home.file = {

  };

  home.sessionVariables = {

  };

  programs.home-manager.enable = true;

}
