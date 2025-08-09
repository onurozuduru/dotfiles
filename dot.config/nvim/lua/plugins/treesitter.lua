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
              -- matchup_matchparen_nomode = "i",
              -- matchup_matchparen_deferred = 1,
            },
          },
        },
      },
    },
  },
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
  -- opts = {
  --   ensure_installed = {
  --     "lua",
  --     "vim",
  --     -- add more arguments for adding more treesitter parsers
  --   },
  -- },
}
