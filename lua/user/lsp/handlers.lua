local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
	local signs = {

		{ name = "DiagnosticSignError", text = "▬" },
		{ name = "DiagnosticSignWarn", text = "▬" },
		{ name = "DiagnosticSignHint", text = "▬" },
		{ name = "DiagnosticSignInfo", text = "▬" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = false, -- disable virtual text
		signs = {
			active = signs, -- show signs
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
	keymap(bufnr, "n", "<leader>lI", "<cmd>Mason<cr>", opts)
	keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  vim.cmd[[ command! Action lua vim.lsp.buf.code_action()<CR>]]
	keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
	vim.cmd[[ command! Nextproblem lua vim.diagnostic.goto_next({buffer=0})<cr>]]
	keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
	vim.cmd[[ command! Prevproblem lua vim.diagnostic.goto_prev({buffer=0})<cr>]]
	keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	vim.cmd[[ command! Rename lua vim.lsp.buf.rename()<cr> ]]
	keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.cmd[[ command! Signaturehelp lua vim.lsp.buf.signature_help()<CR>]]
	keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  vim.keymap.set("n", "<leader>tx", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true})
  vim.keymap.set("n", "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", {silent = true, noremap = true})
  vim.cmd('command! Diagnostic TroubleToggle workspace_diagnostics')
  vim.keymap.set("n", "<leader>td", "<cmd>TroubleToggle document_diagnostics<cr>", {silent = true, noremap = true})
  vim.keymap.set("n", "<leader>tl", "<cmd>TroubleToggle loclist<cr>", {silent = true, noremap = true})
  vim.keymap.set("n", "<leader>tq", "<cmd>TroubleToggle quickfix<cr>", {silent = true, noremap = true})
  vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", {silent = true, noremap = true})
end


M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "lua_ls" then
		client.server_capabilities.documentFormattingProvider = false
	end

	lsp_keymaps(bufnr)

  if client.name == "rust_analyzer" then
    M.hoverAction = function()
      vim.api.nvim_command("RustHoverActions")
      vim.api.nvim_command("RustHoverActions")
    end
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lh", "<cmd>RustHoverActions<CR><cmd>RustHoverActions<CR>", { noremap = true, silent = true})
    vim.cmd('command! HoverAction lua require("user.lsp.handlers").hoverAction()')
  end

	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		return
	end
	illuminate.on_attach(client)
end

return M
