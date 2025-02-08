" Commands registry using a Trie structure

if exists('g:loaded_vimvim_commands')
    finish
endif
let g:loaded_vimvim_commands = 1

" Root node of the Trie
let s:commandTrie = {}

" Registers a new command in the Trie
function! vimvim#commands#RegisterCommand(keys, funcName)
    let node = s:commandTrie
    for char in split(a:keys, '\zs') " Process each character
        if !has_key(node, char)
            let node[char] = {}
        endif
        let node = node[char]
    endfor
    let node['__command__'] = a:funcName " Store function at final node
endfunction

" Retrieves the function name based on input sequence
function! vimvim#commands#GetCommand(keys)
    let node = s:commandTrie
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

" Returns a list of all registered keys, including multi-character ones
function! vimvim#commands#GetAllKeys()
    let result = []
    call s:CollectKeys(s:commandTrie, '', result)
    return result
endfunction

" Debug function to print Trie structure
function! vimvim#commands#PrintTrie()
    echo string(s:commandTrie)
endfunction
