{ config, lib, pkgs, userNames, systemArchitechture, ... }:
{
  imports = [
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = builtins.head userNames;

    networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault systemArchitechture;

  system.stateVersion = "24.11";
}
