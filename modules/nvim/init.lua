local vim = vim
local Plug = vim.fn["plug#"]
vim.call("plug#begin")
--Plug('junegunn/fzf', { ['do'] = function()
--    vim.fn['fzf#install']()
--end })
-- Plug('junegunn/fzf.vim')
-- Plug('junegunn/fzf-lsp.vim')
Plug("nvim-lua/plenary.nvim", { ["commit"] = "2d9b06177a975543726ce5c73fca176cedbffe9d" })
Plug("nvim-telescope/telescope.nvim", { ["commit"] = "85922dde3767e01d42a08e750a773effbffaea3e" })
Plug("neovim/nvim-lspconfig", { ["commit"] = "d01864641c6e43c681c3e9f6cf4745c75fdd9dcc" })
Plug("hrsh7th/cmp-nvim-lsp", { ["commit"] = "39e2eda76828d88b773cc27a3f61d2ad782c922d" })
Plug("hrsh7th/cmp-buffer", { ["commit"] = "3022dbc9166796b644a841a02de8dd1cc1d311fa" })
Plug("hrsh7th/cmp-path", { ["commit"] = "91ff86cd9c29299a64f968ebb45846c485725f23" })
Plug("hrsh7th/cmp-cmdline", { ["commit"] = "d250c63aa13ead745e3a40f61fdd3470efde3923" })
Plug("hrsh7th/nvim-cmp", { ["commit"] = "f17d9b4394027ff4442b298398dfcaab97e40c4f" })
Plug("hrsh7th/cmp-vsnip", { ["commit"] = "989a8a73c44e926199bfd05fa7a516d51f2d2752" })
Plug("hrsh7th/vim-vsnip", { ["commit"] = "02a8e79295c9733434aab4e0e2b8c4b7cea9f3a9" })
Plug("Olical/conjure", { ["commit"] = "bc8907e4ca572720a9f785660781450f8e79ef05" })
Plug("tpope/vim-fugitive", { ["commit"] = "d4877e54cef67f5af4f950935b1ade19ed6b7370" })
Plug("jiangmiao/auto-pairs", { ["commit"] = "39f06b873a8449af8ff6a3eee716d3da14d63a76" }) -- surround?
Plug("kylechui/nvim-surround", { ["commit"] = "dca2e998ff26681ee422b92c6ed39b3d2908d8a9" }) -- surround?
Plug("guns/vim-sexp", { ["commit"] = "14464d4580af43424ed8f2614d94e62bfa40bb4d" })
Plug("tpope/vim-sexp-mappings-for-regular-people", { ["commit"] = "cc5923e357373ea6ef0c13eae82f44e6b9b1d374" })
Plug("stevearc/conform.nvim", { ["commit"] = "e3263eabbfc1bdbc5b6a60ba8431b64e8dca0a79" })
Plug("catppuccin/nvim", { ["commit"] = "637d99e638bc6f1efedac582f6ccab08badac0c6" })

vim.call("plug#end")
require("nvim-surround").setup()

vim.api.nvim_create_user_command("ClojureReload", function()
	vim.g.clojure_reload = true
end, {})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.clj",
	callback = function()
		if vim.g.clojure_reload then
			vim.cmd(":ConjureEval (clj-reload.core/reload)")
		end
	end,
})

vim.cmd.colorscheme("catppuccin")
conform = require("conform")
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },

		clojure = { "cljfmt" },

		nix = { "alejandra" },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		conform.format({ bufnr = args.buf, timeout_ms = 5000 })
	end,
})

conform.formatters.cljfmt = {
	prepend_args = function(self, ctx)
		return { "--remove-multiple-non-indenting-spaces" }
	end,
}

--vim.api.nvim_set_keymap("n", "ag", ":Rg <cr>", { noremap = true})
--vim.api.nvim_set_keymap("n", "ff", ":Files <cr>", { noremap = true})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "cpp", ":ConjureEvalCurrentForm<cr>", { desc = "Eval current form" })
vim.keymap.set("n", "ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Telescope go to lsp definitions" })
vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Telescope references" })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Escape" })
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local cmp = require("cmp")
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
		{ name = "conjure" },
	}, {
		{ name = "buffer" },
	}),
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'git' },
	}, {
		{ name = 'buffer' },
	})
})
require("cmp_git").setup() ]]
--

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
	matching = { disallow_symbol_nonprefix_matching = false },
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("lspconfig")["clojure_lsp"].setup({
	capabilities = capabilities,
})

vim.diagnostic.config({
	virtual_text = true,
	signs = false,
	underline = false,
})
