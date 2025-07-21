{
  lib,
  pkgs,
  libExtra,
  userconfig,
  hostconfig,
  ...
}:
{

  home.username = lib.mkDefault userconfig.name;
  home.homeDirectory = lib.mkDefault "/home/${userconfig.name}";
  home.stateVersion = hostconfig.stateVersion;

  nixpkgs = {
    overlays = libExtra.overlay-list;
    config = libExtra.pkgs-config;
  };

}
