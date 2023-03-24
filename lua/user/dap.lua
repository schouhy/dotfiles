local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
  return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
  return
end

local dap_install_status_ok, dap_install = pcall(require, "dap-install")
if not dap_install_status_ok then
  return
end

dap_install.setup {}

dap_install.config("python", {})
-- add other configs here

dapui.setup {
  expand_lines = true,
  icons = { expanded = "", collapsed = "", circular = "" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.33 },
        { id = "breakpoints", size = 0.17 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 0.33,
      position = "right",
    },
    {
      elements = {
        { id = "repl", size = 0.45 },
        { id = "console", size = 0.55 },
      },
      size = 0.27,
      position = "bottom",
    },
  },
  floating = {
    max_height = 0.9,
    max_width = 0.5, -- Floats will be treated as percentage of your screen.
    border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
}

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


dap.set_log_level('INFO') -- Helps when configuring DAP, see logs with :DapShowLog

-- dap.configurations = {
--     rust = {
--       {
--         type = "rust", -- Which adapter to use
--         request = "launch", -- Whether to "launch" or "attach" to program
--         name = "Debug", -- Human readable name
--         program = "/home/schouhy/Documents/lambda/lambdaworks/target/debug/deps/lambdaworks_plonk-9148f4c90d94339a", -- The buffer you are focused on when running nvim-dap
--       },
  --     }
-- }
require('dap.ext.vscode').load_launchjs("/home/schouhy/.config/nvim/test.json")

dap.adapters.rust = {
  type = "server",
  host = "127.0.0.1",
  port = "${port}",
  executable ={
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
    args = { "--port", "${port}" }
  }
}

