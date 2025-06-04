{
  lib,
  usernames,
  systemArchitechture,
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

  nixpkgs.hostPlatform = lib.mkDefault systemArchitechture;

  system.stateVersion = "24.11";
}
