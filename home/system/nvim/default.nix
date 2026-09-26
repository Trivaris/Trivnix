{ ... }:
{
  home.file = {
    ".config/nvim/preferences.lua".text = ''
      return {
        colorscheme = "catputtin",
        use_lsp = true
      }
    '';
    ".config/nvim" = {
      recursive = true;
      source = ./_config;
    };
  };
}