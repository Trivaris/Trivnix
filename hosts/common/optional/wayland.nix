{ pkgs, ... }:
{
  
  environment.systemPackages = [
    pkgs.grim
    pkgs.waypaper
    pkgs.swww
  ];

}