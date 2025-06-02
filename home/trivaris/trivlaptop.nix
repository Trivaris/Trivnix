{ inputs, config, lib, pkgs, username, system, ... }:
{

  imports = [
    ../common/themes/material-green.nix
    ./home.nix
    ./credentials.nix
    ./programs
  ];

}
