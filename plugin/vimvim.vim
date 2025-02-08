" vimvim.vim - A Vim plugin for Vim
" Author: Alex Plate
" Version: 0.1

if !exists('g:enable_vimvim')
    finish
endif

if exists('g:loaded_vimvim')
    finish
endif
let g:loaded_vimvim = 1

echo "VimVim plugin is loaded. Happy Vimming!"

" Ensure dependencies are loaded
runtime autoload/vimvim/commands.vim
runtime autoload/vimvim/keyprocessor.vim
runtime autoload/vimvim/movement.vim

" Function to handle key dispatch
function! VimVim_KeyDispatcher(key)
    call vimvim#keyprocessor#ProcessKey(a:key)
endfunction

" Register movement commands
call vimvim#commands#RegisterCommand('h', 'vimvim#movement#MoveLeft')
call vimvim#commands#RegisterCommand('l', 'vimvim#movement#MoveRight')
call vimvim#commands#RegisterCommand('j', 'vimvim#movement#MoveDown')
call vimvim#commands#RegisterCommand('k', 'vimvim#movement#MoveUp')

" Register word movement commands
call vimvim#commands#RegisterCommand('w', 'vimvim#movement#MoveWordForward')
call vimvim#commands#RegisterCommand('b', 'vimvim#movement#MoveWordBackward')
call vimvim#commands#RegisterCommand('e', 'vimvim#movement#MoveWordEnd')

" Get all registered keys from the Trie
let s:registered_keys = vimvim#commands#GetAllKeys()

" Map registered keys to dispatcher and suppress original functionality
for key in s:registered_keys
    execute 'nnoremap <silent> ' . key . ' :call VimVim_KeyDispatcher("' . key . '")<CR>'
    execute 'nnoremap <silent> g' . key . ' :call vimvim#movement#ThrowMoveError()<CR>'
endfor
