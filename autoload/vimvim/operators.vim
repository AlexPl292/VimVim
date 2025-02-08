" autoload/vimvim/operators.vim - Handles operator commands

if exists('g:loaded_vimvim_operators')
    finish
endif
let g:loaded_vimvim_operators = 1

" Delete operator
function! vimvim#operators#Delete(start_pos, end_pos)
    " Save the current cursor position
    let save_cursor = getpos('.')
    
    " Get the text in the range
    let start_line = a:start_pos[1]
    let start_col = a:start_pos[2]
    let end_line = a:end_pos[1]
    let end_col = a:end_pos[2]
    
    " Handle single line delete
    if start_line == end_line
        let line = getline(start_line)
        let new_line = strpart(line, 0, start_col - 1) . strpart(line, end_col)
        call setline(start_line, new_line)
    else
        " Handle multi-line delete
        let first_line = getline(start_line)
        let last_line = getline(end_line)
        
        " Create the new first line
        let new_first_line = strpart(first_line, 0, start_col - 1) . strpart(last_line, end_col)
        
        " Delete the lines in between
        execute (start_line + 1) . ',' . end_line . 'delete _'
        
        " Set the new combined line
        call setline(start_line, new_first_line)
    endif
    
    " Restore cursor position
    call setpos('.', save_cursor)
endfunction

" Change operator
function! vimvim#operators#Change(start_pos, end_pos)
    " First delete the text
    call vimvim#operators#Delete(a:start_pos, a:end_pos)
    " Then enter insert mode
    call vimvim#keyprocessor#EnterInsertMode()
endfunction 