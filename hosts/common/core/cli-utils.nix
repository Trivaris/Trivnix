{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    coreutils
    httpie
    fd
    ripgrep
    tldr
    zip
    bat
    git
    wget
  ];

}