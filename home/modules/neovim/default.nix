{ pkgs, ... }:
let
  lazy-plugins = pkgs.stdenv.mkDerivation {
    name = "lua-plugins";
    src = ./plugins;
    installPhase = "cp -r ./ $out/";
  };

  lazyvim-src = pkgs.fetchgit {
    url = "https://github.com/LazyVim/starter";
    rev = "803bc181d7c0d6d5eeba9274d9be49b287294d99";
    hash = "sha256-QrpnlDD4r1X4C8PqBhQ+S3ar5C+qDrU1Jm/lPqyMIFM=";
  };

  lazyvim = pkgs.stdenv.mkDerivation {
    name = "lazyvim";
    src = lazyvim-src;
    
    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
      sed -i 's/enabled = true/enabled = false/' $out/lua/config/lazy.lua
      sed -i '/checker = {/i \ \ rocks = { enabled = false },' $out/lua/config/lazy.lua
      cp -r ${lazy-plugins}/* $out/lua/plugins/
    '';
  };

  tree-sitter-26 = pkgs.tree-sitter.overrideAttrs (oldAttrs:
  let
    version = "0.26.1";
    src = pkgs.fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter";
      tag = "v${version}";
      hash = "sha256-k8X2qtxUne8C6znYAKeb4zoBf+vffmcJZQHUmBvsilA=";
      fetchSubmodules = true;
    };
  in
  {
    inherit version src;
    patches = [];

    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
      pkgs.rustPlatform.bindgenHook
    ];

    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-hnFHYQ8xPNFqic1UYygiLBWu3n82IkTJuQvgcXcMdv0="; 
    };
  });
in
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = [
      pkgs.gcc
      pkgs.gnumake
      pkgs.ripgrep
      pkgs.lazygit
      pkgs.ghostscript
      pkgs.tectonic
      pkgs.mermaid-cli
      pkgs.sqlite
      tree-sitter-26
    ];
  };

  home.file.".config/nvim" = {
    source = lazyvim;
    recursive = true;
  };

}
