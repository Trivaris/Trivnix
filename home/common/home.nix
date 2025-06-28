{
  lib,
  pkgs,
  username,
  stateVersion,
  lib-extra,
  ...
}:
{

  home.username = lib.mkDefault username;
  home.homeDirectory = lib.mkDefault "/home/${username}";
  home.sessionVariables.SHELL = "${pkgs.fish}/bin/fish";
  home.stateVersion = stateVersion;

  nixpkgs = {
    overlays = lib-extra.overlay-list;
    config = lib-extra.pkgs-config;
  };

}
