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
        "clangd",
        "bashls",
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
        "shellcheck",
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "cpptools",
      })
      opts.handlers = {
        cppdbg = function(cppdbg)
          local dap = require "dap"
          dap.adapters.cppdbg = cppdbg.adapters
          dap.configurations.cpp = cppdbg.configurations

          local general_configs = require "plugins.dap.general"
          for _, config in pairs(general_configs.cpp) do
            table.insert(dap.configurations.cpp, config)
          end

          local is_ok, extra_configs = pcall(require, "plugins.dap.extra")
          if is_ok then
            for _, config in pairs(extra_configs.extra) do
              table.insert(dap.configurations.cpp, config)
            end
          end

          -- Add pretty print to all configurations
          for _, cpp_configuration in ipairs(dap.configurations.cpp) do
            local config_pretty_print = {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = true,
            }
            if not cpp_configuration.setupCommands then cpp_configuration["setupCommands"] = {} end
            table.insert(cpp_configuration.setupCommands, config_pretty_print)
          end
          -- Do not close DAP UI after running
          dap.listeners.before.event_terminated["dapui_config"] = nil
          dap.listeners.before.event_exited["dapui_config"] = nil
        end,
      }
    end,
  },
}
