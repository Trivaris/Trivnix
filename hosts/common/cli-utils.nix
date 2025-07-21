{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bat
    btop
    coreutils
    eza
    fastfetch
    fd
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

  programs.fish.enable = true;
}
