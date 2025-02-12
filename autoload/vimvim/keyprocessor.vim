" autoload/vimvim/keyprocessor.vim - Handles key processing and command execution

if exists('g:loaded_vimvim_keyprocessor')
    finish
endif
let g:loaded_vimvim_keyprocessor = 1

" Constants for modes
let s:MODE_NORMAL = 'NORMAL'
let s:MODE_INSERT = 'INSERT'
let s:MODE_OPERATOR_PENDING = 'OPERATOR-PENDING'

" Stores the current input sequence
let s:inputSequence = ''
" Current mode - default to NORMAL
let s:currentMode = s:MODE_NORMAL
" Store the pending operator when in operator-pending mode
let s:pendingOperator = ''

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

        " echo "Key: " . key
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
    elseif s:currentMode ==# s:MODE_OPERATOR_PENDING
        " Process the motion/text object after the operator
        let motion_command = vimvim#commands#GetCommand(s:currentMode, key)
        if motion_command != ''
            " Execute the operator with the motion
            call vimvim#keyprocessor#ExecuteOperatorWithMotion(s:pendingOperator, motion_command)
            let s:pendingOperator = ''
            if s:currentMode ==# s:MODE_OPERATOR_PENDING
                call vimvim#keyprocessor#EnterNormalMode()
            endif
            let s:inputSequence = ''
        else
            " Check if it's a partial match
            if !vimvim#keyprocessor#IsPartialCommand(key)
                " Invalid motion - cancel operator
                let s:pendingOperator = ''
                call vimvim#keyprocessor#EnterNormalMode()
                let s:inputSequence = ''
            else
                let s:inputSequence .= key
            endif
        endif
        return
    endif

    " Normal mode processing
    let s:inputSequence .= key
    let command = vimvim#commands#GetCommand(s:currentMode, s:inputSequence)

    if command != ''
        " Check if this is an operator command
        if vimvim#commands#IsOperator(command)
            let s:pendingOperator = command
            call vimvim#keyprocessor#EnterOperatorPendingMode()
        else
            call vimvim#keyprocessor#ExecuteCommand(command)
        endif
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
    if a:mode ==# s:MODE_NORMAL || a:mode ==# s:MODE_INSERT || a:mode ==# s:MODE_OPERATOR_PENDING
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

" Function to enter operator-pending mode
function! vimvim#keyprocessor#EnterOperatorPendingMode()
    call vimvim#keyprocessor#SetMode(s:MODE_OPERATOR_PENDING)
endfunction

" Execute an operator with a motion
function! vimvim#keyprocessor#ExecuteOperatorWithMotion(operator, motion)
    " Get the range affected by the motion
    let [start_pos, end_pos] = vimvim#movement#GetMotionRange(a:motion)
    
    " Execute the operator on the range
    if exists('*' . a:operator)
        execute 'call ' . a:operator . '(start_pos, end_pos)'
    else
        echohl Error | echom "Unknown operator: " . a:operator | echohl None
    endif
endfunction

function! vimvim#keyprocessor#GetMode()
    return s:currentMode
endfunction

" Debug function to check current mode and input sequence
function! vimvim#keyprocessor#ShowStatus()
    echo "Mode: " . s:currentMode . " | Sequence: " . s:inputSequence
endfunction

" Function to append after cursor
function! vimvim#keyprocessor#AppendAfterCursor()
    call cursor(line('.'), col('.') + 1)
    call vimvim#keyprocessor#EnterInsertMode()
endfunction

" Function to append at end of line
function! vimvim#keyprocessor#AppendAtLineEnd()
    set virtualedit=onemore
    call cursor(line('.'), col('$'))
    call vimvim#keyprocessor#EnterInsertMode()
endfunction

" Function to open new line below
function! vimvim#keyprocessor#OpenLineBelow()
    call append(line('.'), '')
    call cursor(line('.') + 1, 1)
    call vimvim#keyprocessor#EnterInsertMode()
endfunction

" Function to substitute character
function! vimvim#keyprocessor#SubstituteChar()
    let line = getline('.')
    let pos = getpos('.')
    let new_line = strpart(line, 0, pos[2] - 1) . strpart(line, pos[2])
    call setline('.', new_line)
    call vimvim#keyprocessor#EnterInsertMode()
endfunction

" Function to delete character under cursor
function! vimvim#keyprocessor#DeleteChar()
    let line = getline('.')
    let pos = getpos('.')
    let new_line = strpart(line, 0, pos[2] - 1) . strpart(line, pos[2])
    call setline('.', new_line)
endfunction
