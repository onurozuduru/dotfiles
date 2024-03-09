return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "andymass/vim-matchup" },
  init = function()
    vim.g.matchup_matchparen_offscreen = { method = "popup", fullwidth = 1, highlight = "Normal", syntax_hl = 1 }
  end,
  opts = function(_, opts)
    opts.matchup = { enable = true }
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
      "lua"
    })
  end,
}
