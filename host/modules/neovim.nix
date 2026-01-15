{
  programs.nvf = {
    enable = true;
    settings.vim = {
      theme = {
        enable = true;
        style = "dark";
        transparent = true;
      };

      statusline.lualine.enable = true;

      filetree.nvimTree = {
        enable = true;
        setupOpts.git.enable = true;
      };

      autocomplete.nvim-cmp = {
        enable = true;
        sources = {
          nvim_lsp = "[LSP]";
          buffer = "[Buffer]";
          path = "[Path]";
        };
      };

      lsp = {
        enable = true;
        inlayHints.enable = true;
      };

      languages = {
        clang = {
          enable = true;
          lsp.enable = true;
        };

        java = {
          enable = true;
          lsp.enable = true;
        };
      };
    };
  };
}
