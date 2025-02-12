" vimvim.vim - A Vim plugin for Vim
" Author: Alex Plate
" Version: 0.1

if exists('g:loaded_vimvim')
    finish
endif

" Function to load the plugin
function! s:LoadVimVim()
    let g:loaded_vimvim = 1

    " Ensure dependencies are loaded
    runtime autoload/vimvim/commands.vim
    runtime autoload/vimvim/keyprocessor.vim
    runtime autoload/vimvim/movement.vim
    runtime autoload/vimvim/operators.vim

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

    " Register editing commands
    call vimvim#commands#RegisterCommand('NORMAL', 'a', 'vimvim#keyprocessor#AppendAfterCursor')
    call vimvim#commands#RegisterCommand('NORMAL', 'A', 'vimvim#keyprocessor#AppendAtLineEnd')
    call vimvim#commands#RegisterCommand('NORMAL', 'o', 'vimvim#keyprocessor#OpenLineBelow')
    call vimvim#commands#RegisterCommand('NORMAL', 's', 'vimvim#keyprocessor#SubstituteChar')
    call vimvim#commands#RegisterCommand('NORMAL', 'x', 'vimvim#keyprocessor#DeleteChar')

    " Register mode switching commands
    call vimvim#commands#RegisterCommand('NORMAL', 'i', 'vimvim#keyprocessor#EnterInsertMode')
    call vimvim#commands#RegisterCommand('INSERT', '<Esc>', 'vimvim#keyprocessor#EnterNormalMode')

    " Register word movement commands
    call vimvim#commands#RegisterCommand('NORMAL', 'w', 'vimvim#movement#MoveWordForward')
    call vimvim#commands#RegisterCommand('NORMAL', 'b', 'vimvim#movement#MoveWordBackward')
    call vimvim#commands#RegisterCommand('NORMAL', 'e', 'vimvim#movement#MoveWordEnd')

    " Register operators
    call vimvim#commands#RegisterCommand('NORMAL', 'd', 'vimvim#operators#Delete')
    call vimvim#commands#RegisterCommand('NORMAL', 'c', 'vimvim#operators#Change')

    " Register operator-pending mode motions
    call vimvim#commands#RegisterCommand('OPERATOR-PENDING', 'w', 'vimvim#movement#MoveWordForward')
    call vimvim#commands#RegisterCommand('OPERATOR-PENDING', 'b', 'vimvim#movement#MoveWordBackward')
    call vimvim#commands#RegisterCommand('OPERATOR-PENDING', 'e', 'vimvim#movement#MoveWordEnd')
    call vimvim#commands#RegisterCommand('OPERATOR-PENDING', 'h', 'vimvim#movement#MoveLeft')
    call vimvim#commands#RegisterCommand('OPERATOR-PENDING', 'l', 'vimvim#movement#MoveRight')
    call vimvim#commands#RegisterCommand('OPERATOR-PENDING', 'j', 'vimvim#movement#MoveDown')
    call vimvim#commands#RegisterCommand('OPERATOR-PENDING', 'k', 'vimvim#movement#MoveUp')
    call vimvim#commands#RegisterCommand('OPERATOR-PENDING', '$', 'vimvim#movement#MoveToLineEnd')
    call vimvim#commands#RegisterCommand('OPERATOR-PENDING', '0', 'vimvim#movement#MoveToLineStart')

    " Get all registered keys from the Trie for normal mode
    let s:normal_keys = vimvim#commands#GetAllKeys('NORMAL')
    let s:insert_keys = vimvim#commands#GetAllKeys('INSERT')
    let s:operator_pending_keys = vimvim#commands#GetAllKeys('OPERATOR-PENDING')

    " Map registered keys to dispatcher
    for key in s:normal_keys
        let escaped_key = escape(key, "<>")
        execute 'nnoremap <silent> ' . key . ' :call VimVim_KeyDispatcher("' . escaped_key . '")<CR>'
    endfor

    for key in s:insert_keys
        let escaped_key = escape(key, "<>")
        execute 'nnoremap <silent> ' . key . ' :call VimVim_KeyDispatcher("' . escaped_key . '")<CR>'
    endfor

    for key in s:operator_pending_keys
        let escaped_key = escape(key, "<>")
        execute 'nnoremap <silent> ' . key . ' :call VimVim_KeyDispatcher("' . escaped_key . '")<CR>'
    endfor

    nnoremap <silent> <Space>  :call VimVim_KeyDispatcher("\<Space\>")<CR>

    echom "VimVim plugin is loaded. Happy Vimming!"
endfunction

" Create command to load the plugin
command! -nargs=0 LoadVimVim call s:LoadVimVim()

" Auto-load if g:enable_vimvim is set during startup
if exists('g:enable_vimvim') && g:enable_vimvim
    call s:LoadVimVim()
endif
