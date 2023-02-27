local lsp = require("lsp-zero")
local lspUtils = require("lspconfig.util")

lsp.preset("recommended")

lsp.ensure_installed({
	"tsserver",
	"bashls",
	"denols",
	"pyright",
	"rome@nightly",
	"eslint",
	"tsserver",
	"volar",
	"lua_ls",
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
	["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
	["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
	["<C-y>"] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
})

lsp.set_preferences({
	sign_icons = {},
})

lsp.setup_nvim_cmp({
	mapping = cmp_mappings,
})

local on_attach = function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }
	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>vws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "<leader>vd", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "<leader>vca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>vrr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>vrn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
end

lsp.on_attach(on_attach)

-- LUA_LS CONFIG
lsp.configure("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

lsp.configure("rome", {
	root_dir = lspUtils.root_pattern("rome.json"),
	single_file_support = false,
})

-- TSSERVER CUSTOMIZATION
lsp.configure("tsserver", {
	root_dir = lspUtils.root_pattern("package.json"),
	single_file_support = false,
})

-- DENOLS CUSTOMIZATION
lsp.configure("denols", {
	root_dir = lspUtils.root_pattern("deno.json", "deno.jsonc"),
	single_file_support = false,
})

lsp.setup()

-- DUMB LSP ZERO ERRORS
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
})

local null_ls = require("null-ls")
local null_opts = lsp.build_options("null-ls", {})

local function rome_config_exists()
	local current_dir = vim.fn.getcwd()
	local config_file = current_dir .. "/rome.json"
	if vim.fn.filereadable(config_file) == 1 then
		return true
	end

	return false
end

null_ls.setup({
	on_attach = function(client, bufnr)
		null_opts.on_attach(client, bufnr)
	end,
	sources = {
		null_ls.builtins.formatting.rome.with({
			filetypes = {
				"json",
				"svelte",
				"javascript",
				"javascriptreact",
				"vue",
				"typescript",
				"typescriptreact",
				"svelte",
			},
			condition = function()
				return rome_config_exists()
			end,
		}),
		null_ls.builtins.formatting.prettierd.with({
			filetypes = {
				"javascript",
				"javascriptreact",
				"vue",
				"typescript",
				"typescriptreact",
				"svelte",
				"json",
				"jsonc",
				"css",
			},
			condition = function()
				return not rome_config_exists()
			end,
		}),
		null_ls.builtins.formatting.stylua,
		-- You can add tools not supported by mason.nvim
	},
})

-- See mason-null-ls.nvim's documentation for more details:
-- https://github.com/jay-babu/mason-null-ls.nvim#setup
require("mason-null-ls").setup({
	ensure_installed = nil,
	automatic_installation = false, -- You can still set this to `true`
	automatic_setup = true,
})

-- Required when `automatic_setup` is true
require("mason-null-ls").setup_handlers()
