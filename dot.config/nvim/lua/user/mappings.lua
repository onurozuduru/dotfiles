-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    ["<C-s>"] = { "o<esc>k<cr><esc>", desc = "Add newline from normal mode" },
    ["<leader>c"] = { "<cmd>cclose<cr>", desc = "Close files window" },
    -- Remap: Toggle color highlight
    ["<leader>uC"] = false,
    ["<leader>/"] = false,
    ["<leader>h"] = { "<cmd>ColorizerToggle<cr>", desc = "Toggle color highlight" },
    ["<leader>b"] = { name = "Buffers" },
    -- ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
    -- ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
    ["<leader>bl"] = { "<cmd>Neotree toggle buffers<cr>", desc = "Toggle Explorer" },
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(function(bufnr)
          require("astronvim.utils.buffer").close(bufnr)
        end)
      end,
      desc = "Pick to close",
    },
    ["<leader>bc"] = {
      function()
        require("astronvim.utils.buffer").close()
      end,
      desc = "Close buffer",
    },
    L = {
      function()
        require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
      end,
      desc = "Next buffer",
    },
    H = {
      function()
        require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
      end,
      desc = "Previous buffer",
    },
    ["<leader>tp"] = {
      function()
        require("astronvim.utils").toggle_term_cmd({ cmd = "ipython", size = 10, direction = "horizontal" })
      end,
      desc = "ToggleTerm ipython",
    },
    -- ["<leader>tp"] = {
    --   function()
    --     astronvim.toggle_term_cmd({ cmd = "ipython", size = 10, direction = "horizontal" })
    --   end,
    --   desc = "ToggleTerm ipython",
    -- },
    -- ["<leader>c"] = { "<cmd>cclose<cr>", desc = "Close files window" },
  },
  t = {
    ["<esc>"] = { "<C-\\><C-n>", desc = "Escape to terminal normal mode" },
  },
}
