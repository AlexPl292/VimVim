" autoload/vimvim/keyprocessor.vim - Handles key processing and command execution

if exists('g:loaded_vimvim_keyprocessor')
    finish
endif
let g:loaded_vimvim_keyprocessor = 1

" Stores the current input sequence
let s:inputSequence = ''

" Processes a single keypress
function! vimvim#keyprocessor#ProcessKey(key)
    let s:inputSequence .= a:key
    let command = vimvim#commands#GetCommand(s:inputSequence)

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
    let node = s:commandTrie
    for char in split(a:sequence, '\zs')
        if !has_key(node, char)
            return 0  " No valid command starts with this
        endif
        let node = node[char]
    endfor
    return 1
endfunction

" Debug function to check current input sequence
function! vimvim#keyprocessor#ShowSequence()
    echo "Current sequence: " . s:inputSequence
endfunction
