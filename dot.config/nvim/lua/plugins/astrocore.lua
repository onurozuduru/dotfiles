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
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
      signature_help = true, -- enable automatic signature help popup globally on startup
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
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
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
        markdown_fenced_languages = { "plantuml" },
        no_cecutil_maps = "", -- AnsiEsc disable <Leader>swp and <Leader>rwp maps
      },
    },
    -- Disable default key mappings, some of those are linked in astrolsp
    pcall(vim.keymap.del, "n", "gra"), -- Disable LSP code action (already can be accessed from <Leader>l)
    pcall(vim.keymap.del, "n", "gri"), -- Disable LSP go to implementation (already can be accessed from gd)
    pcall(vim.keymap.del, "n", "grn"), -- Disable LSP rename (already can be accessed from <Leader>l)
    pcall(vim.keymap.del, "n", "grr"), -- Disable LSP go to references (will be linked to gr)
    pcall(vim.keymap.del, "n", "gO"), -- Disable LSP document symbols (will be linked to <Leader>lO)
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        ["gl"] = false, -- Hover diagnostics (There is already under <Leader>ld)
        -- ["gra"] = false, -- Disable LSP code action (already can be accessed from <Leader>l)
        -- ["gri"] = false, -- Disable LSP go to implementation (already can be accessed from gd)
        -- ["grn"] = false, -- Disable LSP rename (already can be accessed from <Leader>l)
        -- ["grr"] = false, -- Disable LSP go to references (will be linked to gr)
        ["<Leader>/"] = false, -- Disable comment (there is already gc)
        ["<Leader>Q"] = false, -- Disable Exit AstroNvim (not using)
        ["<Leader>q"] = false, -- Disable Quit window (there is already C-wq)
        ["<Leader>w"] = false, -- Disable Save (not using)
        ["<Leader>o"] = false, -- Disable Toggle explorer focus (not using, Toggle explorer is enough)
        ["<Leader>C"] = false, -- Disable Force close buffer (not using)
        ["<Leader>n"] = false, -- Disable New file (not using)
        ["<Leader>R"] = false, -- Disable Rename file (not using)
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
        -- ["<Leader>bD"] = {
        --   function()
        --     require("astroui.status.heirline").buffer_picker(
        --       function(bufnr) require("astrocore.buffer").close(bufnr) end
        --     )
        --   end,
        --   desc = "Pick to close",
        -- },
        ["<Leader>tp"] = {
          function() require("astrocore").toggle_term_cmd { cmd = "ipython", size = 10, direction = "horizontal" } end,
          desc = "ToggleTerm ipython",
        },
        ["<Leader>mu"] = {
          function()
            if vim.bo.filetype == "markdown" then vim.cmd "TSBufToggle highlight" end
          end,
          desc = "Toggle syntax for PlantUML",
        },
        ["gx"] = { desc = "Opens filepath or URI under cursor" }, -- Make the desc shorter
      },
      t = {
        ["<esc>"] = { "<C-\\><C-n>", desc = "Escape to terminal normal mode" },
      },
      -- i = {
      --   ["<C-S>"] = false, -- Disable force write
      -- },
      x = {
        ["gra"] = false, -- Disable LSP code action (already can be accessed from <Leader>l)
      },
    },
    -- passed to `vim.filetype.add`
    -- filetypes = {
    --   -- see `:h vim.filetype.add` for usage
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     [".foorc"] = "fooscript",
    --   },
    --   pattern = {
    --     [".*/etc/foo/.*"] = "fooscript",
    --   },
    -- },
  },
}
