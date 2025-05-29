{
  pkgs,
  ...
}: {

  home.packages = with pkgs; [
    coreutils
    httpie
    fd
    btop
    procs
    ripgrep
    tldr
    zip
    bat
    fastfetch
    r-matrix
    pipes-rs
    rbonsai
    rsclock
  ];

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    extraOptions = [ "-l" "--icons" "--git" "-a" ];
  };

  programs.fastfetch = {
    enable = true;
  };
    
}