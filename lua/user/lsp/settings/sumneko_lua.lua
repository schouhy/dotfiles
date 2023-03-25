local M = {}

M.opts = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

function M.setup(options)
	local opts = vim.tbl_deep_extend("force", M.opts, options)
  require("lspconfig")["sumneko_lua"].setup(opts)
end

return M
