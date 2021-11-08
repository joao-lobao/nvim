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

let g:startify_fortune_use_unicode = 1

let g:startify_custom_header = [
\'        ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
\'        ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
\'        ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
\'        ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
\'        ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
\'        ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
\'',
\'                                        /~\                           ',
\'                                       |oo )   Vim... we''re doomed!  ',  
\'                                       _\=/_                          ',
\'                       ___            /  _  \                         ',
\'                      /() \          //|/.\|\\                        ',
\'                    _|_____|_       ||  \_/  ||                       ',
\'                   | | === | |      || |\ /| ||                       ',
\'                   |_|  O  |_|       # \_ _/ #                        ',
\'                    ||  O  ||          | | |                          ',
\'                    ||__*__||          | | |                          ',
\'                   |~ \___/ ~|         []|[]                          ',
\'                   /=\ /=\ /=\         | | |                          ',
\'   ________________[_]_[_]_[_]________/_]_[_\______________________   ',
\'                                                         by J.Lobão   ',
\]
