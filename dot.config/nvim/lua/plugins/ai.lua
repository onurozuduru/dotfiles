return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VeryLazy",
    opts = {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-f>a",
          accept_word = false,
          accept_line = "<C-f>l",
          next = "<C-f>s",
          prev = "<C-f>w",
          dismiss = "<C-f>d",
        },
      },
      filetypes = {
        ["*"] = false,
        lua = true,
        cpp = true,
        cmake = true,
        python = true,
        patch = true,
        xml = true,
        markdown = function() return string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "%.adoc") end,
        sh = function() return not string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "%.env.*") end,
      },
    },
    init = function()
      -- Highlight group for Copilot suggestions
      vim.api.nvim_set_hl(0, "CopilotSuggestion", {
        italic = true,
        fg = "#a9a999",
      })
      local copilot_highlight_group = vim.api.nvim_create_augroup("CopilotHighlight", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = copilot_highlight_group,
        callback = function()
          vim.api.nvim_set_hl(0, "CopilotSuggestion", {
            italic = true,
            fg = "#a9a999",
          })
        end,
      })

      -- Add keybindings for Copilot
      require("which-key").add {
        { "<Leader>a", group = "AI" },
        { "<Leader>aP", "<cmd>Copilot panel<CR>", desc = "Open panel of Copilot" },
        { "<Leader>ad", "<cmd>Copilot disable<CR>", desc = "Disable Copilot" },
        { "<Leader>ae", "<cmd>Copilot enable<CR>", desc = "Enable Copilot" },
        { "<Leader>ar", "<cmd>Copilot suggestion<CR>", desc = "Show suggestion" },
        { "<Leader>as", "<cmd>Copilot<CR>", desc = "Status" },
        { "<Leader>av", "<cmd>Copilot version<CR>", desc = "Version" },
      }
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    -- branch = "main",
    event = "VeryLazy",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      question_header = " ",
      answer_header = " ",
      error_header = " ",
      auto_follow_cursor = true,
      highlight_selection = true,
      show_help = true, -- Show help in virtual text, set to true if that's 1st time using Copilot Chat
      clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
      -- context = "buffers",
      mappings = {
        complete = {
          insert = "<Tab>",
        },
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        reset = {
          normal = "<C-l>",
          insert = "<C-l>",
        },
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-CR>",
        },
        toggle_sticky = {
          detail = "Makes line under cursor sticky or deletes sticky line.",
          normal = "gmr",
        },
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
        jump_to_diff = {
          normal = "gmj",
        },
        quickfix_diffs = {
          normal = "gmq",
        },
        yank_diff = {
          normal = "gmy",
          register = '"',
        },
        show_diff = {
          normal = "gmd",
        },
        show_info = {
          normal = "gmi",
        },
        show_help = {
          normal = "gmh",
        },
      },
    },
    config = function(_, opts)
      local chat = require "CopilotChat"
      -- Use unnamed register for the selection
      -- opts.selection = select.unnamed

      opts.system_prompt = (function()
        local base_prompt = require("CopilotChat.config.prompts").COPILOT_INSTRUCTIONS.system_prompt
        local git_dir = vim.fn.finddir(".git", ".;")
        if git_dir ~= "" then
          local root = vim.fn.fnamemodify(git_dir, ":h")
          local instructions_path = root .. "/.github/copilot-instructions.md"
          if vim.fn.filereadable(instructions_path) == 1 then
            local file = io.open(instructions_path, "r")
            if file then
              local content = file:read "*a"
              file:close()
              return base_prompt .. "\nFollowing are additional instructions, apply them when applicable:\n" .. content
            end
          end
        end
        return base_prompt
      end)()

      chat.setup(opts)

      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = true
          vim.opt_local.number = true

          -- Add which-key mappings
          local wk = require "which-key"
          wk.add {
            { "gm", group = "Copilot Chat" },
          }
          -- Get current filetype and set it to markdown if the current filetype is copilot-chat
          local ft = vim.bo.filetype
          if ft == "copilot-chat" then vim.bo.filetype = "markdown" end
          -- Set spell check on in buffer
          vim.opt_local.spell = true
        end,
      })

      require("which-key").add {
        { "<Leader>ac", group = "Copilot Chat" },
      }
      require("which-key").add {
        { "<Leader>a", group = "Copilot Chat", mode = "v" },
      }
    end,

    -- Add keybindings for CopilotChat
    keys = {
      -- Code related commands
      { "<Leader>aC", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
      { "<Leader>ace", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<Leader>act", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      { "<Leader>acr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
      { "<Leader>acR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
      { "<Leader>acn", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
      -- Chat with Copilot in visual mode
      {
        "<Leader>av",
        ":CopilotChat<cr>",
        mode = "x",
        desc = "CopilotChat - Open in vertical split",
      },
      {
        "<Leader>ai",
        function()
          local input = vim.fn.input "Ask Copilot: "
          if input ~= "" then vim.cmd("CopilotChat " .. input) end
        end,
        desc = "CopilotChat - Ask input",
      },
      {
        "<Leader>acq",
        function()
          local input = vim.fn.input "Quick Chat: "
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      {
        "<Leader>ap",
        ":CopilotChatPrompts<cr>",
        mode = "x",
        desc = "CopilotChat - Prompt actions",
      },
    },
  },
}
