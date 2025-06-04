{ pkgs, ... }: {

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
    
    r-matrix
    rbonsai
  ];

}