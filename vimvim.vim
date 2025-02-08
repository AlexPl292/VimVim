" vimvim.vim - A Vim plugin for Vim
" Maintainer: Alex Plate
" Version: 0.1

if exists('g:loaded_custom_movement')
    finish
endif
let g:loaded_custom_movement = 1

" Save the original mapping
let s:save_cpo = &cpo
set cpo&vim

" Error handler function
function! s:ThrowMoveError()
    throw "Use custom movement functions instead of original keys!"
endfunction

" Common function to get current position
function! s:GetPosition()
    let l:pos = getcurpos()
    return [l:pos[1], l:pos[2]]  " Returns [line, column]
endfunction

" Move cursor to new position if valid
function! s:MoveCursor(line, column)
    " Get text of target line
    let l:line_text = getline(a:line)
    let l:line_length = strlen(l:line_text)
    
    " Check if position is valid
    if a:line > 0 && a:line <= line('$') && a:column > 0 && a:column <= l:line_length + 1
        call cursor(a:line, a:column)
    endif
endfunction

" Word movement helper functions
function! s:IsWordChar(char)
    return a:char =~# '\w'
endfunction

function! s:IsWhitespace(char)
    return a:char =~# '\s'
endfunction

" Directional movement functions
function! MoveLeft()
    let [l:line, l:col] = s:GetPosition()
    call s:MoveCursor(l:line, l:col - 1)
endfunction

function! MoveRight()
    let [l:line, l:col] = s:GetPosition()
    call s:MoveCursor(l:line, l:col + 1)
endfunction

function! MoveUp()
    let [l:line, l:col] = s:GetPosition()
    call s:MoveCursor(l:line - 1, l:col)
endfunction

function! MoveDown()
    let [l:line, l:col] = s:GetPosition()
    call s:MoveCursor(l:line + 1, l:col)
endfunction

" Word movement functions
function! MoveWordForward()
    let [l:line, l:col] = s:GetPosition()
    let l:text = getline(l:line)
    let l:len = strlen(l:text)
    let l:pos = l:col - 1  " Convert to 0-based index

    " Skip current word if we're in one
    while l:pos < l:len && s:IsWordChar(l:text[l:pos])
        let l:pos += 1
    endwhile

    " Skip non-word characters
    while l:pos < l:len && !s:IsWordChar(l:text[l:pos])
        let l:pos += 1
    endwhile

    " If we hit the end of line, try next line
    if l:pos >= l:len
        if l:line < line('$')
            call s:MoveCursor(l:line + 1, 1)
        endif
    else
        call s:MoveCursor(l:line, l:pos + 1)
    endif
endfunction

function! MoveWordBackward()
    let [l:line, l:col] = s:GetPosition()
    let l:text = getline(l:line)
    let l:pos = l:col - 2  " Start from previous character

    " If at start of line, move to previous line
    if l:pos < 0
        if l:line > 1
            let l:line -= 1
            let l:text = getline(l:line)
            let l:pos = strlen(l:text) - 1
        endif
    endif

    " Skip non-word characters backwards
    while l:pos >= 0 && !s:IsWordChar(l:text[l:pos])
        let l:pos -= 1
    endwhile

    " Skip word characters backwards
    while l:pos >= 0 && s:IsWordChar(l:text[l:pos])
        let l:pos -= 1
    endwhile

    " Move to start of word
    call s:MoveCursor(l:line, l:pos + 2)
endfunction

function! MoveWordEnd()
    let [l:line, l:col] = s:GetPosition()
    let l:text = getline(l:line)
    let l:len = strlen(l:text)
    let l:pos = l:col - 1

    " Skip non-word characters
    while l:pos < l:len && !s:IsWordChar(l:text[l:pos])
        let l:pos += 1
    endwhile

    " Move to end of word
    while l:pos < l:len && s:IsWordChar(l:text[l:pos])
        let l:pos += 1
    endwhile

    call s:MoveCursor(l:line, l:pos)
endfunction

" Map movement keys to custom functions
nnoremap <silent> h :call MoveLeft()<CR>
nnoremap <silent> j :call MoveDown()<CR>
nnoremap <silent> k :call MoveUp()<CR>
nnoremap <silent> l :call MoveRight()<CR>

" Map arrow keys to custom functions
nnoremap <silent> <Left> :call MoveLeft()<CR>
nnoremap <silent> <Right> :call MoveRight()<CR>
nnoremap <silent> <Up> :call MoveUp()<CR>
nnoremap <silent> <Down> :call MoveDown()<CR>

" Map word movement keys to custom functions
nnoremap <silent> w :call MoveWordForward()<CR>
nnoremap <silent> b :call MoveWordBackward()<CR>
nnoremap <silent> e :call MoveWordEnd()<CR>

" Map original keys to throw errors
nmap gk :call <SID>ThrowMoveError()<CR>
nmap gj :call <SID>ThrowMoveError()<CR>
nmap gh :call <SID>ThrowMoveError()<CR>
nmap gl :call <SID>ThrowMoveError()<CR>
nmap gw :call <SID>ThrowMoveError()<CR>
nmap gb :call <SID>ThrowMoveError()<CR>
nmap ge :call <SID>ThrowMoveError()<CR>
nmap x :call <SID>ThrowMoveError()<CR>

" Restore original mapping settings
let &cpo = s:save_cpo
unlet s:save_cpo
