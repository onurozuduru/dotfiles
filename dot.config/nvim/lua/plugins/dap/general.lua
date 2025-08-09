local dap_configs = {}

local snacks_picker = require "snacks.picker"

dap_configs["helpers"] = {
  select_file = function(search_path)
    search_path = search_path or vim.fn.getcwd()
    local selected = ""
    local co = assert(coroutine.running(), "DAP Program getter needs to be run in coroutine!")

    snacks_picker.pick {
      source = "files",
      title = "Select Executable",
      layout = { preview = false },
      dirs = { search_path },
      cmd = "find",
      args = { "-executable" },
      exclude = { "*/_deps/*", "*/CMakeFiles/*", "*.so*" },
      actions = {
        confirm = function(picker, item)
          selected = snacks_picker.util.path(item)
          picker:close()
        end,
      },
      on_close = function() coroutine.resume(co) end,
    }
    coroutine.yield()

    return selected
  end,

  get_args = function()
    local result = {}
    local args_routine = assert(coroutine.running(), "Args getter needs to be run in coroutine!")
    vim.ui.input({ prompt = "Args: ", default = "" }, function(input)
      result = { tostring(input) }
      coroutine.resume(args_routine)
    end)
    coroutine.yield()
    return result
  end,
}

dap_configs["cpp"] = {
  gtest_common = {
    name = "Launch Gtest",
    type = "cppdbg",
    request = "launch",
    program = function() return dap_configs.helpers.select_file() end,
    args = function() return dap_configs.helpers.get_args() end,
    cwd = "${workspaceFolder}",
    stopAtEntry = false,
  },
}

return dap_configs
