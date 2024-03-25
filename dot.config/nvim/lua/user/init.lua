return {
  -- Set colorscheme to use
  colorscheme = "astrodark",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true,      -- enable or disable format on save globally
        ignore_filetypes = { -- disable format on save for specified filetypes
          "go",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "sumneko_lua",
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    config = {
      clangd = function(opts)
        opts.filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp" }
        opts.root_dir = require("lspconfig.util").root_pattern "compile_commands.json"
        opts.capabilities = { offsetEncoding = "utf-16" }
        return opts
      end,
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = false },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    vim.api.nvim_create_augroup("remove_trailing_white_space", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
      desc = "Remove trailing white space",
      group = "remove_trailing_white_space",
      pattern = "*",
      command = "%s/\\s\\+$//e",
    })

    vim.api.nvim_create_augroup("spell_checking", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Enable spell checking for all files",
      group = "spell_checking",
      pattern = { "text", "markdown" },
      command = "setlocal spell",
    })
    vim.api.nvim_create_autocmd("TermOpen", {
      desc = "Disable spell checking for terminal",
      group = "spell_checking",
      pattern = "*",
      command = "setlocal nospell",
    })

    vim.api.nvim_create_augroup("go_formatting", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
      desc = "Format go code",
      group = "go_formatting",
      pattern = "*.go",
      command = "silent! lua require('go.format').goimport()",
    })

    -- -- Hack to make mason to patch shared lib in Nix
    -- require("mason-registry"):on("package:install:success", function(pkg)
    --   pkg:get_receipt():if_present(function(receipt)
    --     -- Figure out the interpreter inspecting nvim itself
    --     -- This is the same for all packages, so compute only once
    --     local cmd =
    --     'patchelf --print-interpreter $(rg -oN "/nix/store/[a-z0-9]+-neovim-unwrapped-[0-9]+\\.[0-9]+\\.[0-9]+/bin/nvim" $(which nvim))'
    --     local handle = assert(io.popen(cmd, "r"))
    --     local interpreter = assert(handle:read("*a"))
    --     handle:close()
    --
    --     for _, rel_path in pairs(receipt.links.bin) do
    --       local bin_abs_path = pkg:get_install_path() .. "/" .. rel_path
    --       if pkg.name == "lua-language-server" then
    --         bin_abs_path = pkg:get_install_path() .. "/extension/server/bin/lua-language-server"
    --       end
    --
    --       -- Set the interpreter on the binary
    --       os.execute(("patchelf --set-interpreter %q %q"):format(interpreter, bin_abs_path))
    --     end
    --   end)
    -- end)
  end,
}
