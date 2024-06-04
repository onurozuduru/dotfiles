return {
  {
    "Exafunction/codeium.vim",
    event = "VeryLazy",

    config = function()
      vim.g.codeium_tab_fallback = ""
      vim.g.codeium_no_map_tab = true
      vim.g.codeium_disable_bindings = true
      vim.g.codeium_enabled = false
      vim.g.codeium_filetypes_disabled_by_default = true
      vim.g.codeium_filetypes = {
        ["rust"] = true,
        ["cpp"] = true,
        ["sh"] = true,
        ["python"] = true,
        ["lua"] = true,
      }

      -- Disable codeium in buffer
      -- vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      --   pattern = "*",
      --   callback = function() vim.fn["codeium#command#Command"] "DisableBuffer" end,
      -- })

      -- Register keybindings to which-key for normal mode
      require("which-key").register {
        ["<Leader>a"] = {
          name = "󰟷 AI",
          d = { "<cmd>Codeium Disable<cr>", "Disable Codeium" },
          e = { "<cmd>Codeium Enable<cr>", "Enable Codeium" },
          b = { "<cmd>Codeium DisableBuffer<cr>", "Buffer disable Codeium" },
          B = { "<cmd>Codeium EnableBuffer<cr>", "Buffer enable Codeium" },
          s = { "<cmd>lua print(vim.fn['codeium#GetStatusString']())<cr>", "Status" },
          C = { "<cmd>call codeium#Chat()<cr>", "Chat" },
        },
      }

      -- Highlight suggestions with different than comment
      vim.cmd [[ hi CodeiumSuggestion guifg=#a9a999 gui=italic ]]
    end,

    -- Change keybindings for insert mode
    keys = function()
      return {
        { "<M-Bslash>", mode = "i", false },
        { "<M-]>", mode = "i", false },
        { "<M-[>", mode = "i", false },
        { "<C-]>", mode = "i", false },
        {
          "<C-f>a",
          function() return vim.fn["codeium#Accept"]() end,
          mode = "i",
          expr = true,
          desc = "Codeium accept",
        },
        {
          "<C-f>s",
          function() return vim.fn["codeium#CycleCompletions"](1) end,
          mode = "i",
          expr = true,
          desc = "Codeium next",
        },
        {
          "<C-f>w",
          function() return vim.fn["codeium#CycleCompletions"](-1) end,
          mode = "i",
          expr = true,
          desc = "Codeium prev",
        },
        {
          "<C-f>d",
          function() return vim.fn["codeium#Clear"]() end,
          mode = "i",
          expr = true,
          desc = "Codeium clear",
        },
      }
    end,
  },
}
