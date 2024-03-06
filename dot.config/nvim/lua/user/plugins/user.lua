return {
  "aperezdc/vim-template",
  "tpope/vim-surround",
  "tpope/vim-fugitive",
  "powerman/vim-plugin-AnsiEsc",
  "wellle/targets.vim",
  "p00f/clangd_extensions.nvim",
  "LnL7/vim-nix",
  {
    "lewis6991/spellsitter.nvim",
    config = function() require("spellsitter").setup() end,
  },
  -- {
  --   "ray-x/go.nvim",
  --   config = function()
  --     require("go").setup()
  --   end,
  --   branch = "nvim_0.8",
  -- },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      local cfg = {
        debug = false,                                             -- set to true to enable debug logging
        log_path = vim.fn.stdpath "cache" .. "/lsp_signature.log", -- log dir when debug is on
        -- default is  ~/.cache/nvim/lsp_signature.log
        verbose = false,                                           -- show debug line number

        bind = true,                                               -- this is mandatory, otherwise border config won't get registered.
        -- if you want to hook lspsaga or other signature handler, pls set to false
        doc_lines = 10,                                            -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
        -- set to 0 if you do not want any api comments be shown
        -- this setting only take effect in insert mode, it does not affect signature help in normal
        -- mode, 10 by default
        max_height = 12,                       -- max height of signature floating_window
        max_width = 80,                        -- max_width of signature floating_window
        wrap = true,                           -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
        floating_window = true,                -- show hint in a floating window, set to false for virtual text only mode
        floating_window_above_cur_line = true, -- try to place the floating above the current line when possible note:
        -- will set to true when fully tested, set to false will use whichever side has more space
        -- this setting will be helpful if you do not want the pum and floating win overlap
        floating_window_off_x = 1, -- adjust float windows x position.
        floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
        close_timeout = 4000, -- close floating window after ms when laster parameter is entered
        fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
        hint_enable = true, -- virtual hint enable
        hint_prefix = " ", -- panda for parameter, note: for the terminal not support emoji, might crash
        hint_scheme = "string",
        hi_parameter = "lspsignatureactiveparameter", -- how your parameter will be highlight
        handler_opts = {
          border = "double", -- double, rounded, single, shadow, none
        },
        always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
        auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
        extra_trigger_chars = {}, -- array of extra characters that will trigger signature completion, e.g., {"(", ","}
        zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom
        padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
        transparency = nil, -- disabled by default, allow floating win transparent value 1~100
        shadow_blend = 36, -- if you using shadow as border use this set the opacity
        shadow_guibg = "black", -- if you using shadow as border use this set the color e.g. 'green' or '#121315'
        timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
        toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<m-x>'
        select_signature_key = "<F12>", -- cycle to next signature, e.g. '<m-n>' function overloading
        move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
      }
      require("lsp_signature").setup(cfg)
    end,
    opt = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = false,
      window = {
        mappings = {
          h = false,
          l = false,
          ["_"] = "parent_or_close",
          ["-"] = "child_or_open",
          ["Z"] = "expand_all_nodes",
        },
      },
      renderers = {
        directory = {
          { "diagnostics",   errors_only = true },
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
}
