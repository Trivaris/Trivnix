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

  options.homeModules.nvim.enable = mkEnableOption "nvim";

  config = mkIf cfg.nvim.enable {
    home.packages = with pkgs; [
      neovim
    ];

    home.file.".config/nvim" = {
      source = "${inputs.dotfiles}/nvim";
      recursive = true;
    };
  };

}
