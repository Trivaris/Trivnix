{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bat
    btop
    coreutils
    eza
    fastfetch
    fd
    fish
    fzf
    git
    httpie
    neovim
    pipes-rs
    procs
    rbonsai
    ripgrep
    rmatrix
    rsclock
    tldr
    wget
    zip
    zoxide
  ];
}
