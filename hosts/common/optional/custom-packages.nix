{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    r-matrix
    rbonsai
  ];

}