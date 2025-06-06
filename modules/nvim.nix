{ pkgs, config, lib, inputs, ... }:
let
  cfg = config.modules;
in
with lib;
{

  options.modules.nvim = mkEnableOption "nvim";

  config = mkIf cfg.nvim {
    home.packages = with pkgs; [
      neovim
    ];

    home.file.".config/nvim" = {
      source = "${inputs.dotfiles}/nvim";
      recursive = true;
    };
  };

}
