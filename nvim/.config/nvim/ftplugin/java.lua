-- Starts jdtls via nvim-jdtls (instead of the generic vim.lsp.enable path) so that
-- require('jdtls').setup_dap() can register the 'java' DAP adapter. Without this,
-- nvim-dap has no 'java' adapter even though jdtls itself is running as an LSP.
local ok, jdtls = pcall(require, "jdtls")
if not ok then
	return
end

local mason_registry = require("mason-registry")

-- java-debug-adapter provides the debug server backing the 'java' DAP adapter;
-- java-test adds JUnit/TestNG test-discovery and run/debug support.
local bundles = {}
for _, pkg_name in ipairs({ "java-debug-adapter", "java-test" }) do
	local pkg = mason_registry.get_package(pkg_name)
	local install_path = pkg:get_install_path()
	vim.list_extend(bundles, vim.split(vim.fn.glob(install_path .. "/extension/server/*.jar"), "\n", { trimempty = true }))
end

local root_markers = {
	"mvnw", -- Maven
	"gradlew", -- Gradle
	"settings.gradle", -- Gradle
	"settings.gradle.kts", -- Gradle
	"build.xml", -- Ant
	"pom.xml", -- Maven
	"build.gradle", -- Gradle
	"build.gradle.kts", -- Gradle
	".git", -- last resort for multi-module maven projects
}
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
	return
end

local function get_jdtls_jvm_args()
	local env = os.getenv("JDTLS_JVM_ARGS")
	local args = {}
	for a in string.gmatch(env or "", "%S+") do
		table.insert(args, string.format("--jvm-arg=%s", a))
	end
	return args
end

local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local cmd = { "jdtls", "-data", workspace_dir }
vim.list_extend(cmd, get_jdtls_jvm_args())

-- Capabilities advertised to the server: merge nvim defaults with what nvim-cmp adds.
local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = cmp_ok
	and vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_nvim_lsp.default_capabilities())
	or vim.lsp.protocol.make_client_capabilities()

jdtls.start_or_attach({
	cmd = cmd,
	root_dir = root_dir,
	capabilities = capabilities,
	init_options = {
		bundles = bundles,
	},
	on_attach = function()
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		-- Auto-discovers project main classes and adds them as dap.configurations.java entries
		require("jdtls.dap").setup_dap_main_class_configs()
	end,
})
