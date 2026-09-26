{ pkgs, ... }:
{
  home.packages = [ pkgs.neovim pkgs.neovim-qt ];
  xdg.configFile = {
    "nvim/lua/preferences.lua".text = ''
      return {
        colorscheme = "catputtin",
        use_lsp = true
      }
    '';
    "nvim" = {
      recursive = true;
      source = ./_config;
    };
  };
}