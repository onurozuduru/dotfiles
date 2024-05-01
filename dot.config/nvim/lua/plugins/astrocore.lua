-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    icons_enabled = true,
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        clipboard = "", -- disable joining clipboards `clipboard=unnammedplus`
        cmdheight = 1,
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        templates_no_autocmd = 1,
        templates_directory = "~/file_templates",
        templates_global_name_prefix = "tpl",
        username = "Onur Ozuduru",
      },
    },
    -- Mappings can be configured through AstroCore as well.
    mappings = {
      -- first key is the mode
      n = {
        ["<Leader>/"] = false, -- Disable comment (there is already gc)
        ["<Leader>Q"] = false, -- Disable Exit AstroNvim (not using)
        ["<Leader>w"] = false, -- Disable Save (not using)
        ["<Leader>o"] = false, -- Disable Toggle explorer focus (not using, Toggle explorer is enough)
        -- ["<C-s>"] = { "o<esc>k<cr><esc>", desc = "Add newline from normal mode" },
        ["<C-S>"] = { "o<esc><esc>", desc = "Add newline from normal mode" },
        ["<Leader>c"] = { "<cmd>cclose<cr>", desc = "Close files window" },
        ["<Leader>uz"] = false, -- Remap: Toggle color highlight
        ["<Leader>h"] = { "<cmd>ColorizerToggle<cr>", desc = "Toggle color highlight" },
        ["<Leader>bl"] = { "<cmd>Neotree toggle buffers<cr>", desc = "Toggle Explorer" },
        ["<Leader>bc"] = {
          function() require("astrocore.buffer").close() end,
          desc = "Close buffer",
        },
        -- navigate buffer tabs with `H` and `L`
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        ["<Leader>tp"] = {
          function() require("astrocore").toggle_term_cmd { cmd = "ipython", size = 10, direction = "horizontal" } end,
          desc = "ToggleTerm ipython",
        },
      },
      t = {
        ["<esc>"] = { "<C-\\><C-n>", desc = "Escape to terminal normal mode" },
      },
    },
  },
}
