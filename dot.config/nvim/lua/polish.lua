-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here
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
  pattern = { "text", "markdown", "lua" },
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

-- Below are mapped from vim script so needs to be removed in here
-- Disable <Leader>swp Save win position (not using)
-- Disable <Leader>rwp Restore win position (not using)
vim.cmd [[
unmap <Leader>swp
unmap <Leader>rwp
]]

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
