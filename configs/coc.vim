let g:coc_global_extensions = [
      \ 'coc-yank',
      \ 'coc-tsserver',
      \ 'coc-tslint-plugin',
      \ 'coc-prettier',
      \ 'coc-json',
      \ 'coc-html',
      \ 'coc-eslint',
      \ 'coc-css',
      \ 'coc-angular',
      \ 'coc-vimlsp',
      \ 'coc-git',
      \ 'coc-markdownlint',
      \ 'coc-markdown-preview-enhanced',
      \ 'coc-marketplace',
      \ 'coc-webview',
      \ 'coc-emmet',
      \ 'coc-tabnine',
      \ 'coc-ultisnips',
      \ 'coc-calc',
      \ ]

nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
nnoremap <silent> Q :CocCommand calc.append<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <leader>dp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>dn <Plug>(coc-diagnostic-next)
nmap <silent> <leader>mo :CocCommand markdown-preview-enhanced.openPreview<CR>
nmap <silent> <leader>mf :CocCommand markdownlint.fixAll<CR>
nmap <silent> <leader>cg :CocCommand git.showCommit<CR>
nnoremap <leader>f :CocFix<CR>
nnoremap <leader>gu :CocCommand git.chunkUndo<CR>
nnoremap <leader>gs :CocCommand git.chunkStage<CR>
" Formatting selected code.
xmap <leader>p <Plug>(coc-format)
nmap <leader>p <Plug>(coc-format)


" -------------BEGIN COC BOILERPLATE-------------
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <F2> <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

command! -nargs=* -range CocAction :call coc#rpc#notify('codeActionRange', [<line1>, <line2>, <f-args>])
command! -nargs=* -range CocFix    :call coc#rpc#notify('codeActionRange', [<line1>, <line2>, 'quickfix'])
" -------------END COC BOILERPLATE-------------

