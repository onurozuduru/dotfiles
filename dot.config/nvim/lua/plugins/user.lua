---@type LazySpec
return {
  { "max397574/better-escape.nvim", enabled = false },
  { "stevearc/resession.nvim", enabled = false },
  "aperezdc/vim-template",
  "tpope/vim-surround",
  "tpope/vim-fugitive",
  "powerman/vim-plugin-AnsiEsc",
  "wellle/targets.vim",
  "p00f/clangd_extensions.nvim",
  -- "LnL7/vim-nix",
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        "⬛⬛⬛⬛⬛⬛🟦🟦🟦🟦⬛⬛⬛⬛⬛⬛",
        "⬛⬛⬛⬛🟦🟦🟦🟦🟦🟦🟦🟦⬛⬛⬛⬛",
        "⬛⬛⬛🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦⬛⬛⬛",
        "⬛⬛🟦🌫️🌫️🟦🟦🟦🟦🌫️🌫️🟦🟦🟦⬛⬛",
        "⬛⬛🌫️🌫️🌫️🌫️🟦🟦🌫️🌫️🌫️🌫️🟦🟦⬛⬛",
        "⬛⬛🟦🟦🌫️🌫️🟦🟦🟦🟦🌫️🌫️🟦🟦⬛⬛",
        "⬛🟦🟦🟦🌫️🌫️🟦🟦🟦🟦🌫️🌫️🟦🟦🟦⬛",
        "⬛🟦🟦🌫️🌫️🟦🟦🟦🟦🌫️🌫️🟦🟦🟦🟦⬛",
        "⬛🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦⬛",
        "⬛🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦⬛",
        "⬛🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦⬛",
        "⬛🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦⬛",
        "⬛🟦🟦⬛🟦🟦🟦⬛⬛🟦🟦🟦⬛🟦🟦⬛",
        "⬛🟦⬛⬛⬛🟦🟦⬛⬛🟦🟦⬛⬛⬛🟦⬛",
      }
      return opts
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      },
      merge_keywords = false,
      highlight = {
        multiline = false, -- enable multine todo comments
        keyword = "bg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        pattern = [[.*<(KEYWORDS)\s*(\(*.*\)|:)]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      search = {
        pattern = [[\b(KEYWORDS)(\(|:)]],
      },
    },
  },
  -- Already included in astro
  -- {
  --   "L3MON4D3/LuaSnip",
  --   config = function(plugin, opts)
  --     require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
  --     -- add more custom luasnip configuration such as filetype extend or custom snippets
  --     -- local luasnip = require "luasnip"
  --     -- luasnip.store_selection_keys = nil
  --   end,
  -- },
  {
    "AstroNvim/astrotheme",
    -- version = "^1.7.0",
    optional = true,
    opts = {
      style = {
        italic_comments = false, -- Bool value, toggles italic comments.
        simple_syntax_colors = true, -- Bool value, simplifies the amounts of colors used for syntax highlighting.
      },
      highlights = {
        astrodark = {
          modify_hl_groups = function(hl, c) -- modify_hl_groups function allows you to modify hl groups,
            hl.Search = { fg = c.ui.base, bg = c.ui.yellow }
            hl.IncSearch = { fg = c.ui.yellow, bg = c.ui.base }
          end,
          ["DiagnosticDeprecated"] = { strikethrough = false, underline = true },
          ["DiagnosticUnnecessary"] = { italic = true, underline = true },
        },
      },
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      -- debug = false, -- set to true to enable debug logging
      -- log_path = vim.fn.stdpath "cache" .. "/lsp_signature.log", -- log dir when debug is on
      -- default is  ~/.cache/nvim/lsp_signature.log
      -- verbose = false, -- show debug line number

      doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
      -- set to 0 if you do not want any api comments be shown
      -- this setting only take effect in insert mode, it does not affect signature help in normal

      -- max_height = 12, -- max height of signature floating_window
      -- max_width = 80, -- max_width of signature floating_window
      -- wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
      -- floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
      -- floating_window_above_cur_line = true, -- try to place the floating above the current line when possible note:
      -- will set to true when fully tested, set to false will use whichever side has more space
      -- this setting will be helpful if you do not want the pum and floating win overlap

      -- floating_window_off_x = 1, -- adjust float windows x position.
      -- floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
      -- close_timeout = 4000, -- close floating window after ms when laster parameter is entered
      -- fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
      hint_enable = true, -- virtual hint enable
      hint_prefix = " ", -- panda for parameter, note: for the terminal not support emoji, might crash
      hint_scheme = "String",
      hi_parameter = "lspsignatureactiveparameter", -- how your parameter will be highlight
      handler_opts = {
        border = "double", -- double, rounded, single, shadow, none
      },
      -- always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
      -- zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom
      -- timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
      -- toggle_key = "<C-X>", -- toggle signature on and off in insert mode,  e.g. toggle_key = '<m-x>'
      -- toggle_key_flip_floatwin_setting = true,
      -- select_signature_key = "<F12>", -- cycle to next signature, e.g. '<m-n>' function overloading
      -- move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
    },
    config = function(_, opts) require("lsp_signature").setup(opts) end,
    -- Workaround since select_signature_key is not working correctly
    keys = function()
      return {
        {
          "<F12>",
          function() require("lsp_signature").signature { trigger = "NextSignature" } end,
          mode = "i",
          expr = true,
          desc = "Select Signature",
        },
        {
          "<C-X>",
          function() require("lsp_signature").toggle_float_win() end,
          mode = "i",
          expr = true,
          desc = "Toggle signature help",
        },
      }
    end,
    opt = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = false,
      default_component_configs = {
        git_status = {
          symbols = {
            added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = "", -- this can only be used in the git_status source
            renamed = "󰁕", -- this can only be used in the git_status source
            untracked = "",
            ignored = "󱋭",
            unstaged = "󰄗",
            staged = "󰄵",
            conflict = "",
          },
        },
      },
      window = {
        width = 45,
        mappings = {
          h = false,
          l = false,
          ["_"] = "parent_or_close",
          ["-"] = "child_or_open",
          ["z"] = "expand_all_nodes",
          ["Z"] = "close_all_nodes",
        },
      },
      renderers = {
        directory = {
          -- { "diagnostics",   errors_only = true },
          { "clipboard" },
          { "indent" },
          { "icon" },
          { "current_filter" },
          { "name" },
        },
        file = {
          { "indent" },
          { "clipboard" },
          { "bufnr" },
          { "modified" },
          { "diagnostics" },
          { "git_status" },
          { "icon" },
          {
            "name",
            use_git_status_colors = true,
            zindex = 10,
          },
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
        commands = {
          expand_all_nodes = function(state)
            -- Solution: https://github.com/nvim-neo-tree/neo-tree.nvim/issues/777#issuecomment-1685959836
            local node = state.tree:get_node()
            local filesystem_commands = require "neo-tree.sources.filesystem.commands"
            filesystem_commands.expand_all_nodes(state, node)
          end,
        },
      },
    },
  },
  {
    "onurozuduru/himarkdown.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      captures = {
        title = { mark = "" },
        quote = { mark = "󰝗" },
        dash = { mark = "󰇘" },
      },
    },
    lazy = false,
    keys = {
      { "<Leader>m", function() require("himarkdown").toggle() end, desc = "Toggle HiMarkdown" },
    },
  },
  -- {
  --   "lukas-reineke/headlines.nvim",
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   init = function(_)
  --     vim.cmd [[
  --       highlight default link Quote @markup.quote
  --     ]]
  --   end,
  --   opts = {
  --     markdown = {
  --       bullets = { "" },
  --       dash_string = "󰇘",
  --       fat_headlines = false,
  --     },
  --   },
  -- },
}
