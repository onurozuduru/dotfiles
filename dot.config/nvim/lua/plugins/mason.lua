-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "lua_ls",
        -- add more arguments for adding more language servers
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "stylua",
        -- add more arguments for adding more null-ls sources
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        -- "python",
        -- add more arguments for adding more debuggers
      })
      opts.handlers = {
        cppdbg = function(cppdbg)
          local dap = require "dap"
          dap.adapters.cppdbg = cppdbg.adapters
          dap.configurations.cpp = cppdbg.configurations
          table.insert(dap.configurations.cpp, {
            name = "Launch Gtest",
            type = "cppdbg",
            request = "launch",
            program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
            args = function() return { vim.fn.input "Args: " } end,
            cwd = "${workspaceFolder}",
            stopAtEntry = false,
          })
          for _, cpp_configuration in ipairs(dap.configurations.cpp) do
            local config_pretty_print = {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            }
            if not cpp_configuration.setupCommands then cpp_configuration["setupCommands"] = {} end
            table.insert(cpp_configuration.setupCommands, config_pretty_print)
          end
          -- dap.listeners.before.event_terminated["dapui_config"] = nil
          -- dap.listeners.before.event_exited["dapui_config"] = nil
        end,
      }
    end,
  },
}
