{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "nvim" prefs.cli.enabled) {
    programs.nvf = {
      enable = true;
      settings.vim = {
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        lsp.enable = true;

        languages = {
          enableTreesitter = true;
          nix.enable = true;
          java.enable = true;
          kotlin.enable = true;
        };
      };
    };
  };
}
