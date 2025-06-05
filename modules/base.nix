{
  lib,
  pkgs,
  username,
  stateVersion,
  ...
}:
{

  home.username = lib.mkDefault username;
  home.homeDirectory = lib.mkDefault "/home/${username}";
  home.sessionVariables.SHELL = "${pkgs.fish}/bin/fish";

  home.stateVersion = stateVersion;

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

}
