-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

-- add list of plugins to install
return packer.startup(function(use)
	-- Have packer manage itself
	use({ "wbthomason/packer.nvim", opt = true })
	-- speed loading Lua modules and files.
	use("lewis6991/impatient.nvim")
	-- plugin for statusline
	use({ "nvim-lualine/lualine.nvim" })
	-- plugin for surrounding feature
	use({ "tpope/vim-surround" })
	-- plugin commentary feature
	use({ "tpope/vim-commentary" })
	-- repeat commands from other plugins that are not atomic to vim
	use({ "tpope/vim-repeat" })
	-- color highlighter
	use({ "norcalli/nvim-colorizer.lua" })
	-- plugin for git integration
	use({ "tpope/vim-fugitive" })
	-- improve syntax highlighting
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	-- to create custom mappings for text objects (ex: `daf` to delete a function)
	use({ "nvim-treesitter/nvim-treesitter-textobjects" })
	-- colorschemes
	use({ "ellisonleao/gruvbox.nvim" })
	-- easily run tests
	use({ "janko/vim-test" })
	-- telescope functionality
	use({ "nvim-lua/popup.nvim" })
	use({ "nvim-lua/plenary.nvim" })
	use({ "nvim-telescope/telescope.nvim" })
	-- changes the working directory to the project root when a file or directory
	-- is opened
	use({ "airblade/vim-rooter" })
	-- package.json dependencies manager helpers
	use({ "vuki656/package-info.nvim" })
	use({ "MunifTanjim/nui.nvim" })
	-- alternate files / naviagation cmds / buffer configuration
	use({ "tpope/vim-projectionist" })
	-- file explorer
	use({ "nvim-tree/nvim-tree.lua" })
	-- dev icons for multiple plugins
	-- requires a Nerd Font
	use({ "nvim-tree/nvim-web-devicons" })

	-- autocompletion
	use("hrsh7th/nvim-cmp") -- completion plugin
	use("hrsh7th/cmp-buffer") -- source for text in buffer
	use("hrsh7th/cmp-path") -- source for file system paths
	use({ "tzachar/cmp-tabnine", run = "./install.sh" })
	use({ "hrsh7th/cmp-calc" })

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("saadparwaiz1/cmp_luasnip") -- for autocompletion
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- managing & installing lsp servers, linters & formatters
	use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig

	-- configuring lsp servers
	use("neovim/nvim-lspconfig") -- easily configure language servers
	use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
	use({ "glepnir/lspsaga.nvim", branch = "main" }) -- enhanced lsp uis
	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
	use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion
	use({ "ray-x/lsp_signature.nvim" })

	-- formatting & linting
	use("jose-elias-alvarez/null-ls.nvim") -- configure formatters & linters
	use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls

	-- auto closing
	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- git integration
	use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

	-- refactor/extract tool
	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	})
	-- adds a scroll bar
	use("petertriho/nvim-scrollbar")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
