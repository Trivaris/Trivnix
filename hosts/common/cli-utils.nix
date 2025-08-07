{ pkgs, ... }:
{

  environment.systemPackages = builtins.attrValues {

    inherit (pkgs)
      # Core utilities
      coreutils
      wget
      zip
      jq

      # Shell enhancements
      eza
      fd
      ripgrep
      fzf
      zoxide
      tldr

      # System monitoring / info
      btop
      procs
      fastfetch
      rsclock

      # Dev tools
      git
      neovim

      # Networking / API
      httpie

      # Fun / visuals
      bat
      pipes-rs
      rmatrix
      rbonsai
      ;

  };

  programs.fish.enable = true;
  programs.tmux.enable = true;
  programs.zoxide.enable = true;

}
