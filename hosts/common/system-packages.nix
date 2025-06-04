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
    neovim
    git
    fish
    wget
    sops
    age

    r-matrix
    rbonsai
  ];

}
