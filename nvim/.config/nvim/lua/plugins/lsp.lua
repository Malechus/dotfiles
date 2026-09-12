local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup({
	ui = { border = "rounded" },
	-- Crashdummyy's registry carries a build of the Roslyn language server that tracks
	-- the version shipped with VS Code's C# extension; the default registry's copy lags behind.
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})

mason_lspconfig.setup({
	ensure_installed = { "jdtls" },
})

-- Capabilities advertised to the server: merge nvim defaults with what nvim-cmp adds.
-- cmp_nvim_lsp is lazy-required here so this file can load even before PlugInstall.
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = ok
	and vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_nvim_lsp.default_capabilities())
	or vim.lsp.protocol.make_client_capabilities()

-- Replaces OmniSharp: roslyn.nvim drives the actively maintained Roslyn LSP (the same
-- server VS Code's C# extension uses) instead of the discontinued OmniSharp, which
-- has a long-standing bug where it emits a bare JSON `null` message that Neovim's LSP
-- client cannot parse (logged as "INVALID_SERVER_MESSAGE: vim.NIL").
require("roslyn").setup({
	config = {
		capabilities = capabilities,
	},
})

vim.lsp.enable({ "jdtls" })
