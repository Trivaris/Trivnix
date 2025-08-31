{ pkgs, ... }:
{

  environment.systemPackages = builtins.attrValues {

    inherit (pkgs)
      coreutils
      wget
      zip
      jq

      eza
      fd
      ripgrep
      fzf
      zoxide
      tldr

      btop
      procs
      fastfetch
      rsclock

      git
      neovim

      httpie

      bat
      pipes-rs
      rmatrix
      rbonsai
      espanso-wayland
      adbautoplayer
      android-tools
      protonvpn-gui
      chromium
      ;

  };

  programs.fish.enable = true;
  programs.tmux.enable = true;
  programs.zoxide.enable = true;

}
