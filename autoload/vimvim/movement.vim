" Get current cursor position
function! vimvim#movement#GetPosition()
    let l:pos = getcurpos()
    return [l:pos[1], l:pos[2]]  " [line, column]
endfunction

" Move cursor if position is valid
function! vimvim#movement#MoveCursor(line, column)
    let l:line_text = getline(a:line)
    let l:line_length = strlen(l:line_text)

    if a:line > 0 && a:line <= line('$') && a:column > 0 && a:column <= l:line_length + 1
        call cursor(a:line, a:column)
    endif
endfunction

" Check if a character is part of a word
function! vimvim#movement#IsWordChar(char)
    return a:char =~# '\w'
endfunction

" Check if a character is whitespace
function! vimvim#movement#IsWhitespace(char)
    return a:char =~# '\s'
endfunction

" Directional movement functions
function! vimvim#movement#MoveLeft()
    let [l:line, l:col] = vimvim#movement#GetPosition()
    call vimvim#movement#MoveCursor(l:line, l:col - 1)
endfunction

function! vimvim#movement#MoveRight()
    let [l:line, l:col] = vimvim#movement#GetPosition()
    call vimvim#movement#MoveCursor(l:line, l:col + 1)
endfunction

function! vimvim#movement#MoveUp()
    let [l:line, l:col] = vimvim#movement#GetPosition()
    call vimvim#movement#MoveCursor(l:line - 1, l:col)
endfunction

function! vimvim#movement#MoveDown()
    let [l:line, l:col] = vimvim#movement#GetPosition()
    call vimvim#movement#MoveCursor(l:line + 1, l:col)
endfunction

" Move forward by word
function! vimvim#movement#MoveWordForward()
    let [l:line, l:col] = vimvim#movement#GetPosition()
    let l:text = getline(l:line)
    let l:len = strlen(l:text)
    let l:pos = l:col - 1

    while l:pos < l:len && vimvim#movement#IsWordChar(l:text[l:pos])
        let l:pos += 1
    endwhile

    while l:pos < l:len && !vimvim#movement#IsWordChar(l:text[l:pos])
        let l:pos += 1
    endwhile

    if l:pos >= l:len && l:line < line('$')
        call vimvim#movement#MoveCursor(l:line + 1, 1)
    else
        call vimvim#movement#MoveCursor(l:line, l:pos + 1)
    endif
endfunction

" Move backward by word
function! vimvim#movement#MoveWordBackward()
    let [l:line, l:col] = vimvim#movement#GetPosition()
    let l:text = getline(l:line)
    let l:pos = l:col - 2

    if l:pos < 0 && l:line > 1
        let l:line -= 1
        let l:text = getline(l:line)
        let l:pos = strlen(l:text) - 1
    endif

    while l:pos >= 0 && !vimvim#movement#IsWordChar(l:text[l:pos])
        let l:pos -= 1
    endwhile

    while l:pos >= 0 && vimvim#movement#IsWordChar(l:text[l:pos])
        let l:pos -= 1
    endwhile

    call vimvim#movement#MoveCursor(l:line, l:pos + 2)
endfunction

" Move to the end of the word
function! vimvim#movement#MoveWordEnd()
    let [l:line, l:col] = vimvim#movement#GetPosition()
    let l:text = getline(l:line)
    let l:len = strlen(l:text)
    let l:pos = l:col - 1

    while l:pos < l:len && !vimvim#movement#IsWordChar(l:text[l:pos])
        let l:pos += 1
    endwhile

    while l:pos < l:len && vimvim#movement#IsWordChar(l:text[l:pos])
        let l:pos += 1
    endwhile

    call vimvim#movement#MoveCursor(l:line, l:pos)
endfunction

" Get the range affected by a motion
function! vimvim#movement#GetMotionRange(motion)
    " Save current position
    let start_pos = getpos('.')
    
    " Execute the motion to get end position
    if exists('*' . a:motion)
        execute 'call ' . a:motion . '()'
    endif
    let end_pos = getpos('.')
    
    " Ensure start_pos is before end_pos
    if start_pos[1] > end_pos[1] || (start_pos[1] == end_pos[1] && start_pos[2] > end_pos[2])
        let temp = start_pos
        let start_pos = end_pos
        let end_pos = temp
    endif
    
    " Return to original position
    call setpos('.', start_pos)
    
    return [start_pos, end_pos]
endfunction

" Line end motion
function! vimvim#movement#MoveToLineEnd()
    call cursor(line('.'), col('$'))
endfunction

" Line start motion
function! vimvim#movement#MoveToLineStart()
    call cursor(line('.'), 1)
endfunction
