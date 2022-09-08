" STEPS TO FOLLOW AFTER NEW UBUNTU FRESH INSTALL
" 1 - install Vim Plug with the following command:
"   - sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" 2 - install xclip (sudo apt-get install xclip)
" 3 - install lazygit https://github.com/jesseduffield/lazygit#installation
" 4 - install ripgrep (sudo apt install ripgrep) for live_grep functionality
" 5 - install a Nerd Font:
"   - download a font from nerd fonts (ex: https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.ttf)
"   - add the downloaded file on ~/.fonts
"   - select the font from the list on the terminal preferences font settings

call plug#begin('~/.config/nvim/plugged')
" plugin for statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" plugin for auto pairs feature
Plug 'jiangmiao/auto-pairs'
" plugin for surrounding feature
Plug 'tpope/vim-surround'
" plugin commentary feature
Plug 'tpope/vim-commentary'
" repeat commands from other plugins that are not atomic to vim
Plug 'tpope/vim-repeat'
" color highlighter
Plug 'ap/vim-css-color'
" plugin for git integration
Plug 'tpope/vim-fugitive'
" improve syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" to create custom mappings for text objects (ex: `daf` to delete a function)
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
" gruvbox colorscheme
Plug 'gruvbox-community/gruvbox'
" plugin for intelisense for multiple languages; has own extensions for
" multiple languages
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" fancy startup plugin
Plug 'mhinz/vim-startify'
" easily run tests
Plug 'janko/vim-test'
" telescope functionality
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" changes the working directory to the project root when a file or directory
" is opened
Plug 'airblade/vim-rooter'
" dev icons in telescope
" requires a Nerd Font
Plug 'kyazdani42/nvim-web-devicons'
" snippets
Plug 'SirVer/ultisnips'
" package.json dependencies manager helpers
Plug 'vuki656/package-info.nvim'
Plug 'MunifTanjim/nui.nvim'
" alternate files / naviagation cmds / buffer configuration
Plug 'tpope/vim-projectionist'
" cool marks feature, attaches on the gutter the mark associated with each line
Plug 'kshenoy/vim-signature'
" provides two text objects: ax and ix. They represent XML/HTML attributes.
Plug 'kana/vim-textobj-user' | Plug 'whatyouhide/vim-textobj-xmlattr'
" terminal in vim
Plug 'voldikss/vim-floaterm'
" vim plugin to use GHCup from within vim buffers.
Plug 'hasufell/ghcup.vim'
" neovim dependency to ghcup.vim
Plug 'rbgrouleff/bclose.vim'
call plug#end()

" configurations
source ~/.config/nvim/configs/general.vim
source ~/.config/nvim/configs/coc.vim
source ~/.config/nvim/configs/airline.vim
source ~/.config/nvim/configs/package-info.vim
source ~/.config/nvim/configs/startify.vim
source ~/.config/nvim/configs/telescope.vim
source ~/.config/nvim/configs/treesitter.vim
source ~/.config/nvim/configs/nvim-treesitter-textobjects.vim
source ~/.config/nvim/configs/ultisnips.vim
source ~/.config/nvim/configs/vim-fugitive.vim
source ~/.config/nvim/configs/vim-projectionist.vim
source ~/.config/nvim/configs/vim-test.vim
source ~/.config/nvim/configs/vim-floaterm.vim

