{
  lib,
  pkgs,
  username,
  stateVersion,
  libExtra,
  ...
}:
{

  home.username = lib.mkDefault username;
  home.homeDirectory = lib.mkDefault "/home/${username}";
  home.sessionVariables.SHELL = "${pkgs.fish}/bin/fish";
  home.stateVersion = stateVersion;

  nixpkgs = {
    overlays = libExtra.overlay-list;
    config = libExtra.pkgs-config;
  };

}
