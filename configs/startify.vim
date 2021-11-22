nnoremap <leader>S :Startify<CR>

let g:startify_lists = [
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ { 'type': 'files',     'header': ['   Files']            },
          \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
          \ ]

let g:startify_bookmarks = [
            \ { 'v': '~/.config/nvim/init.vim' },
            \ { 't': '~/.tmux.conf' },
            \ { 'z': '~/.zshrc' },
            \ { 'n': '~/Desktop/coding/notes/index.md' },
            \ { 'd': '~/Desktop/dotfiles' },
            \ { 'c': '~/Desktop/coding/crypto-watcher/src/app/components/table/table.component.ts' },
            \ ]

let g:startify_session_persistence = 1

