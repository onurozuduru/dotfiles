-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    {
      "andymass/vim-matchup",
      dependencies = {
        "AstroNvim/astrocore",
        opts = {
          options = {
            g = {
              matchup_matchparen_offscreen = { method = "popup", fullwidth = 1, highlight = "Normal", syntax_hl = 1 },
            },
          },
        },
      },
    },
  },
  -- dependencies = { "andymass/vim-matchup" },
  -- init = function()
  --   vim.g.matchup_matchparen_offscreen = { method = "popup", fullwidth = 1, highlight = "Normal", syntax_hl = 1 }
  -- end,
  opts = function(_, opts)
    opts.matchup = { enable = true }
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "lua",
      "vim",
      "cpp",
      "markdown",
      "markdown_inline",
    })
  end,
}
