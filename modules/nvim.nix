{ pkgs, inputs, ... }:
{

  home.packages = with pkgs; [
    neovim
  ];

  home.file.".config/nvim" = {
    source = "${inputs.dotfiles}/nvim";
    recursive = true;
  };

}
