local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup({
	ui = { border = "rounded" },
})

mason_lspconfig.setup({
	ensure_installed = { "omnisharp", "jdtls" },
})

-- Capabilities advertised to the server: merge nvim defaults with what nvim-cmp adds.
-- cmp_nvim_lsp is lazy-required here so this file can load even before PlugInstall.
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = ok
	and vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_nvim_lsp.default_capabilities())
	or vim.lsp.protocol.make_client_capabilities()

local omnisharp_extended_ok, omnisharp_extended = pcall(require, "omnisharp_extended")

vim.lsp.config("omnisharp", {
	capabilities = capabilities,
	-- Use the extended handler so go-to-definition works on decompiled sources.
	-- OmniSharp sometimes returns omnisharp://metadata URIs that the default handler cannot open.
	handlers = omnisharp_extended_ok and {
		["textDocument/definition"] = omnisharp_extended.handler,
	} or nil,
	settings = {
		omnisharp = {
			-- Only load projects explicitly opened, not the whole solution tree up-front.
			enableMsBuildLoadProjectsOnDemand = true,
			enableRoslynAnalyzers = true,
			organizeImportsOnFormat = true,
			enableEditorConfigSupport = true,
		},
	},
})

vim.lsp.enable({ "omnisharp", "jdtls" })
