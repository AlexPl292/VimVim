" vimvim.vim - A Vim plugin for Vim
" Maintainer: Alex Plate
" Version: 0.1

if exists('g:loaded_vimvim')
    finish
endif
let g:loaded_vimvim = 1

" Load movement mappings
nnoremap <silent> h :call vimvim#movement#MoveLeft()<CR>
nnoremap <silent> j :call vimvim#movement#MoveDown()<CR>
nnoremap <silent> k :call vimvim#movement#MoveUp()<CR>
nnoremap <silent> l :call vimvim#movement#MoveRight()<CR>

nnoremap <silent> <Left> :call vimvim#movement#MoveLeft()<CR>
nnoremap <silent> <Right> :call vimvim#movement#MoveRight()<CR>
nnoremap <silent> <Up> :call vimvim#movement#MoveUp()<CR>
nnoremap <silent> <Down> :call vimvim#movement#MoveDown()<CR>

nnoremap <silent> w :call vimvim#movement#MoveWordForward()<CR>
nnoremap <silent> b :call vimvim#movement#MoveWordBackward()<CR>
nnoremap <silent> e :call vimvim#movement#MoveWordEnd()<CR>

" Map original keys to throw errors
nnoremap <silent> gk :call vimvim#movement#ThrowMoveError()<CR>
nnoremap <silent> gj :call vimvim#movement#ThrowMoveError()<CR>
nnoremap <silent> gh :call vimvim#movement#ThrowMoveError()<CR>
nnoremap <silent> gl :call vimvim#movement#ThrowMoveError()<CR>
nnoremap <silent> gw :call vimvim#movement#ThrowMoveError()<CR>
nnoremap <silent> gb :call vimvim#movement#ThrowMoveError()<CR>
nnoremap <silent> ge :call vimvim#movement#ThrowMoveError()<CR>
nnoremap <silent> x :call vimvim#movement#ThrowMoveError()<CR>
