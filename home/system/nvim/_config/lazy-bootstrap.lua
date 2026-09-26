local preferences = require("preferences")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyDerivation = "github:Trivaris/TrivnixNvim/ff3aa7e157d9b63545d62d1a8e6c098a7d00dd95#lazy-nvim-src";
    local out = vim.fn.system({ "nix", "build", lazyDerivation, "-o", lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to build lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = { { import = "plugins" } },
    install = { colorscheme = { preferences.colorscheme } },
    checker = { enabled = false },
})