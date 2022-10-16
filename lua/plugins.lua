vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Install your plugins here
return require('packer').startup(function(use)
  -- My plugins here

  -- Have packer manage itself
  use({ "wbthomason/packer.nvim", opt = true }) 
  -- plugin for statusline
  use({ 'nvim-lualine/lualine.nvim' })
  -- plugin for auto pairs feature
  use({ 'jiangmiao/auto-pairs' })
  -- plugin for surrounding feature
  use({ 'tpope/vim-surround' })
  -- plugin commentary feature
  use({ 'tpope/vim-commentary' })
  -- repeat commands from other plugins that are not atomic to vim
  use({ 'tpope/vim-repeat' })
  -- color highlighter
  use({ 'ap/vim-css-color' })
  -- plugin for git integration
  use({ 'tpope/vim-fugitive' })
  -- improve syntax highlighting
  use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
  -- to create custom mappings for text objects (ex: `daf` to delete a function)
  use({ 'nvim-treesitter/nvim-treesitter-textobjects' })
  -- gruvbox colorscheme
  use({ 'gruvbox-community/gruvbox' })
  -- plugin for intelisense for multiple languages; has own extensions for
  -- multiple languages
  use({ 'neoclide/coc.nvim', branch = 'release' })
  -- fancy startup plugin
  use({ 'mhinz/vim-startify' })
  -- easily run tests
  use({ 'janko/vim-test' })
  -- telescope functionality
  use({ 'nvim-lua/popup.nvim' })
  use({ 'nvim-lua/plenary.nvim' })
  use({ 'nvim-telescope/telescope.nvim' })
  -- changes the working directory to the project root when a file or directory
  -- is opened
  use({ 'airblade/vim-rooter' })
  -- dev icons in telescope
  -- requires a Nerd Font
  use({ 'kyazdani42/nvim-web-devicons' })
  -- snippets
  use({ 'SirVer/ultisnips' })
  -- package.json dependencies manager helpers
  use({ 'vuki656/package-info.nvim' })
  use({ 'MunifTanjim/nui.nvim' })
  -- alternate files / naviagation cmds / buffer configuration
  use({ 'tpope/vim-projectionist' })
  -- cool marks feature, attaches on the gutter the mark associated with each line
  use({ 'kshenoy/vim-signature' })
  -- provides two text objects: ax and ix. They represent XML/HTML attributes.
  use({ 'kana/vim-textobj-user' })
  use({ 'whatyouhide/vim-textobj-xmlattr' })
  -- terminal in vim
  use({ 'voldikss/vim-floaterm' })
  -- run a snippet of code without ever leaving neovim
  use({ 'arjunmahishi/flow.nvim' })
  --extends increment and decrement functionality for toggling boolean values as
  --well as days of the week, months, and ROYGBIV color names
  use({ 'nat-418/boole.nvim' })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
