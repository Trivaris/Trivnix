{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Core utilities
    coreutils
    wget
    zip

    # Shell enhancements
    eza          # modern ls replacement
    fd           # simpler find
    ripgrep      # faster grep
    fzf          # fuzzy finder
    zoxide       # smarter cd
    tldr         # simplified man pages

    # System monitoring / info
    btop         # resource monitor
    procs        # modern ps replacement
    fastfetch    # system info display
    rsclock      # terminal clock

    # Development tools
    git
    neovim

    # Networking / API
    httpie       # human-friendly HTTP client

    # Fun / visuals
    bat          # syntax-highlighted cat
    pipes-rs     # terminal pipes animation
    rmatrix      # matrix rain effect
    rbonsai      # terminal bonsai tree

    # TUI Clients
    nchat
    instagram-cli
    gurk-rs
    discordo
  ];

  programs.fish.enable = true;
  programs.tmux.enable = true;
  programs.zoxide.enable = true;
}
