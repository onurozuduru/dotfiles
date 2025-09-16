-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",
        "clangd",
        "bash-language-server",
        "marksman",

        -- install formatters
        "stylua",
        "shellcheck",

        -- install debuggers
        "cpptools",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "marksman" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      handlers = {
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
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function(plugin, opts)
      -- run default AstroNvim nvim-dap-ui configuration function
      require "astronvim.plugins.configs.nvim-dap-ui"(plugin, opts)

      -- disable dap events that are created
      local dap = require "dap"
      -- dap.listeners.after.event_initialized.dapui_config = nil
      dap.listeners.before.event_terminated.dapui_config = nil
      dap.listeners.before.event_exited.dapui_config = nil
    end,
  },
}
