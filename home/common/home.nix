{
  lib,
  pkgs,
  libExtra,
  username,
  hostconfig,
  ...
}:
{

  home.username = lib.mkDefault username;
  home.homeDirectory = lib.mkDefault "/home/${username}";
  home.sessionVariables.SHELL = "${pkgs.fish}/bin/fish";
  home.stateVersion = hostconfig.stateVersion;

  nixpkgs = {
    overlays = libExtra.overlay-list;
    config = libExtra.pkgs-config;
  };

}
