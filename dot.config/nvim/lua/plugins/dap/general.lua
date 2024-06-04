local dap_configs = {}

dap_configs["helpers"] = {
  select_file = function(search_path)
    search_path = search_path or vim.fn.getcwd()
    local actions = require "telescope.actions"

    local selected = ""
    local current_coroutine = assert(coroutine.running(), "DAP Program getter needs to be run in coroutine!")

    local get_selection = function(prompt_bufnr)
      local actions_state = require "telescope.actions.state"
      local selected_entry = actions_state.get_selected_entry()
      selected = vim.fn.fnamemodify(selected_entry.path, ":p")
      actions.close(prompt_bufnr)
      coroutine.resume(current_coroutine)
    end

    require("telescope.builtin").find_files {
      previewer = false,
      find_command = {
        "find",
        search_path,
        "-executable",
        "-type",
        "f",
        "!",
        "-path",
        "*/_deps/*",
        "!",
        "-path",
        "*/CMakeFiles/*",
      },
      attach_mappings = function(_, _)
        actions.select_default:replace(get_selection)
        return true
      end,
    }
    -- Pause until get_selection() makes it resume
    coroutine.yield()
    return selected
  end,
}

dap_configs["cpp"] = {
  gtest_common = {
    name = "Launch Gtest",
    type = "cppdbg",
    request = "launch",
    program = function() return dap_configs.helpers.select_file() end,
    args = function() return { vim.fn.input "Args: " } end,
    cwd = "${workspaceFolder}",
    stopAtEntry = false,
  },
}

return dap_configs
