{
  lib,
  pkgs,
  username,
  stateVersion,
  pkgsLib,
  ...
}:
{

  home.username = lib.mkDefault username;
  home.homeDirectory = lib.mkDefault "/home/${username}";
  home.sessionVariables.SHELL = "${pkgs.fish}/bin/fish";
  home.stateVersion = stateVersion;

  nixpkgs = {
    overlays = pkgsLib.overlayList;
    config = pkgsLib.pkgsConfig;
  };

}
