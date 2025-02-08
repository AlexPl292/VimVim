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
    " echo "Key dispatcher called with: " . a:key
    call vimvim#keyprocessor#ProcessKey(a:key)
endfunction

" Register movement commands
call vimvim#commands#RegisterCommand('NORMAL', 'h', 'vimvim#movement#MoveLeft')
call vimvim#commands#RegisterCommand('NORMAL', 'l', 'vimvim#movement#MoveRight')
call vimvim#commands#RegisterCommand('NORMAL', 'j', 'vimvim#movement#MoveDown')
call vimvim#commands#RegisterCommand('NORMAL', 'k', 'vimvim#movement#MoveUp')

" Register mode switching commands
call vimvim#commands#RegisterCommand('NORMAL', 'i', 'vimvim#keyprocessor#EnterInsertMode')
call vimvim#commands#RegisterCommand('INSERT', '<Esc>', 'vimvim#keyprocessor#EnterNormalMode')

" Register word movement commands
call vimvim#commands#RegisterCommand('NORMAL', 'w', 'vimvim#movement#MoveWordForward')
call vimvim#commands#RegisterCommand('NORMAL', 'b', 'vimvim#movement#MoveWordBackward')
call vimvim#commands#RegisterCommand('NORMAL', 'e', 'vimvim#movement#MoveWordEnd')

" Get all registered keys from the Trie for normal mode
let s:normal_keys = vimvim#commands#GetAllKeys('NORMAL')
let s:insert_keys = vimvim#commands#GetAllKeys('INSERT')

" Map registered keys to dispatcher and suppress original functionality
for key in s:normal_keys
    let escaped_key = escape(key, "<>")
    execute 'nnoremap <silent> ' . key . ' :call VimVim_KeyDispatcher("' . escaped_key . '")<CR>'
endfor

for key in s:insert_keys
    let escaped_key = escape(key, "<>")
    execute 'nnoremap <silent> ' . key . ' :call VimVim_KeyDispatcher("' . escaped_key . '")<CR>'
endfor
