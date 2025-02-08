" autoload/vimvim/keyprocessor.vim - Handles key processing and command execution

if exists('g:loaded_vimvim_keyprocessor')
    finish
endif
let g:loaded_vimvim_keyprocessor = 1

" Constants for modes
let s:MODE_NORMAL = 'NORMAL'
let s:MODE_INSERT = 'INSERT'

" Stores the current input sequence
let s:inputSequence = ''
" Current mode - default to NORMAL
let s:currentMode = s:MODE_NORMAL

" Processes a single keypress
function! vimvim#keyprocessor#ProcessKey(key)
    " echo "Processing key: " . a:key
    " Remove backslashes from the key
    let key = substitute(a:key, '\\', '', 'g')
    
    if s:currentMode ==# s:MODE_INSERT
        " Check if there's a command for this key in insert mode
        let command = vimvim#commands#GetCommand(s:currentMode, key)
        if command != ''
            call vimvim#keyprocessor#ExecuteCommand(command)
            return
        endif
        
        " If no command exists, insert the key as text
        let pos = getpos('.')  " Get cursor position [bufnum, lnum, col, off]
        let line = getline('.')
        let char = key
        
        " Handle special keys
        if key ==# '<Space>'
            let char = ' '
        elseif key ==# '<Tab>'
            let char = "\t"
        elseif key ==# '<CR>'
            " Split the line at cursor position
            let before = strpart(line, 0, pos[2] - 1)
            let after = strpart(line, pos[2] - 1)
            call setline('.', before)
            call append(pos[1] - 1, after)
            call cursor(pos[1] + 1, 1)
            return
        endif
        
        " Insert character at cursor position
        let new_line = strpart(line, 0, pos[2] - 1) . char . strpart(line, pos[2] - 1)
        call setline('.', new_line)
        call cursor(pos[1], pos[2] + 1)  " Move cursor right
        return
    endif

    " Normal mode processing
    let s:inputSequence .= key
    let command = vimvim#commands#GetCommand(s:currentMode, s:inputSequence)

    if command != ''
        call vimvim#keyprocessor#ExecuteCommand(command)
        let s:inputSequence = ''  " Reset sequence after execution
    else
        " Check if it's a partial match or invalid input
        if !vimvim#keyprocessor#IsPartialCommand(s:inputSequence)
            let s:inputSequence = ''  " Reset if no valid command starts with it
        endif
    endif
endfunction

" Executes a function based on the command name
function! vimvim#keyprocessor#ExecuteCommand(command)
    if exists('*' . a:command)
        execute 'call ' . a:command . '()'
    else
        echohl Error | echom "Unknown command: " . a:command | echohl None
    endif
endfunction

" Checks if any command starts with the given input sequence (for multi-key commands)
function! vimvim#keyprocessor#IsPartialCommand(sequence)
    let node = s:commandTries[s:currentMode]
    for char in split(a:sequence, '\zs')
        if !has_key(node, char)
            return 0  " No valid command starts with this
        endif
        let node = node[char]
    endfor
    return 1
endfunction

" Mode management functions
function! vimvim#keyprocessor#SetMode(mode)
    if a:mode ==# s:MODE_NORMAL || a:mode ==# s:MODE_INSERT
        let s:currentMode = a:mode
        " Optional: Show mode change in status line
        echo "-VimVim- " . s:currentMode . " --"
    endif
endfunction

" Function to enter insert mode
function! vimvim#keyprocessor#EnterInsertMode()
    set virtualedit=onemore
    call vimvim#keyprocessor#SetMode(s:MODE_INSERT)
endfunction

" Function to enter normal mode
function! vimvim#keyprocessor#EnterNormalMode()
    set virtualedit=
    call vimvim#keyprocessor#SetMode(s:MODE_NORMAL)
endfunction

function! vimvim#keyprocessor#GetMode()
    return s:currentMode
endfunction

" Debug function to check current mode and input sequence
function! vimvim#keyprocessor#ShowStatus()
    echo "Mode: " . s:currentMode . " | Sequence: " . s:inputSequence
endfunction
