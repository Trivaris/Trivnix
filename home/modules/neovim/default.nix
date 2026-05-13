{ pkgs, ... }:
{

  home.packages = [ pkgs.neovim ];

  home.file.".config/nvim" = {
    source = pkgs.nvim-dotfiles.override {
      colorscheme = "tokyonight";
    };
    recursive = true;
  };

}
