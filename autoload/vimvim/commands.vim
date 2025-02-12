" Commands registry using a Trie structure

if exists('g:loaded_vimvim_commands')
    finish
endif
let g:loaded_vimvim_commands = 1

" Dict of tries for different modes
if !exists('g:vimvim_commandTries')
    let g:vimvim_commandTries = {
        \ 'NORMAL': {},
        \ 'INSERT': {}
    \ }
endif

" Registers a new command in the Trie for specific mode
function! vimvim#commands#RegisterCommand(mode, keys, funcName)
    if !has_key(g:vimvim_commandTries, a:mode)
        let g:vimvim_commandTries[a:mode] = {}
    endif
    
    let node = g:vimvim_commandTries[a:mode]
    for char in split(a:keys, '\zs')
        if !has_key(node, char)
            let node[char] = {}
        endif
        let node = node[char]
    endfor
    let node['__command__'] = a:funcName
endfunction

" Retrieves the function name based on input sequence and mode
function! vimvim#commands#GetCommand(mode, keys)
    if !has_key(g:vimvim_commandTries, a:mode)
        return ''
    endif
    
    let node = g:vimvim_commandTries[a:mode]
    for char in split(a:keys, '\zs')
        if !has_key(node, char)
            return ''
        endif
        let node = node[char]
    endfor
    return get(node, '__command__', '')
endfunction

" Helper function to recursively collect all keys in the Trie
function! s:CollectKeys(node, prefix, result)
    for key in keys(a:node)
        if key == '__command__'
            call add(a:result, a:prefix)
        else
            call s:CollectKeys(a:node[key], a:prefix . key, a:result)
        endif
    endfor
endfunction

" Returns a list of all registered keys for a specific mode
function! vimvim#commands#GetAllKeys(mode)
    let result = []
    if has_key(g:vimvim_commandTries, a:mode)
        call s:CollectKeys(g:vimvim_commandTries[a:mode], '', result)
    endif
    return result
endfunction

" Debug function to print Trie structure for a mode
function! vimvim#commands#PrintTrie(mode)
    echo string(get(g:vimvim_commandTries, a:mode, {}))
endfunction

" Check if a command is an operator
function! vimvim#commands#IsOperator(command)
    let operators = [
        \ 'vimvim#operators#Delete',
        \ 'vimvim#operators#Change'
    \ ]
    return index(operators, a:command) >= 0
endfunction
