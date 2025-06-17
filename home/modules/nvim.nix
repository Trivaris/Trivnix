{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.homeModules;
in
with lib;
{

  options.homeModules.nvim = mkEnableOption "nvim";

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
