{
  outputs,
  lib,
  trivnixLib,
  hostInfos,
  userInfos,
  ...
}:
{
  home.username = lib.mkDefault userInfos.name;
  home.homeDirectory = lib.mkDefault "/home/${userInfos.name}";
  home.stateVersion = hostInfos.stateVersion;

  nixpkgs = {
    overlays = builtins.attrValues (outputs.overlays);
    config = trivnixLib.pkgsConfig;
  };
}
