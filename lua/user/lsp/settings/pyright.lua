local M = {}

M.opts = {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
      },
    },
  },
}

function M.setup(options)
	local opts = vim.tbl_deep_extend("force", M.opts, options)
  require("lspconfig")["pyright"].setup(opts)
end

return M

