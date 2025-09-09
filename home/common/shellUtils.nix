{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs.kdePackages) kcalc dolphin ark;

    inherit (pkgs)
      coreutils
      wget
      zip
      jq
      eza
      fd
      fzf
      zoxide
      tldr
      btop
      procs
      fastfetch
      git
      httpie
      bat
      android-tools

      rsclock
      pipes-rs
      rmatrix
      rbonsai
      adbautoplayer
      me3

      hardinfo2
      protonvpn-gui
      vlc
      wayland-utils
      wl-clipboard-rs
      ;
  };
}
