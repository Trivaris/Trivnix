{
  outputs,
  lib,
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
    overlays = builtins.attrValues (outputs.overlays);
    config = libExtra.pkgs-config;
  };

}
