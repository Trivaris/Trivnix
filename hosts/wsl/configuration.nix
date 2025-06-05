{
  lib,
  usernames,
  stateVersion,
  architecture,
  hostname,
  ...
}:
{

  imports = [
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = builtins.head usernames;
  wsl.wslConf.network.hostname = hostname;

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault architecture;

  system.stateVersion = stateVersion;
}
