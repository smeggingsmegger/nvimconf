function! fxns#InsertDebugLine(str, lnum) abort
  let line = getline(a:lnum)
  if strridx(line, a:str) != -1
    normal! dd
  else
    let plnum = prevnonblank(a:lnum)
    call append(line('.')-1, repeat(' ', indent(plnum)).a:str)
    normal! k
  endif

  " Save file without any events
  if &modifiable && &modified | noautocmd write | endif
endfunction

" Send the selected hunk to Slack using slackcat
function! fxns#Slack() range abort
  execute ':' . a:firstline . ',' . a:lastline . 'w !slackcat -t ' . &filetype . ' -T ' . bufname('%')
endfunction

" Install vimproc
" https://github.com/Shougo/vimproc.vim
function! fxns#MakeVimProc(info) abort
  if a:info.status ==# 'installed' || a:info.force
    if has('win32')
      !tools\\update-dll-mingw
    elseif has('mac')
      !make -f make_mac.mak
    else
      !make
    endif
  endif
endfunction

" Function to compile Less to CSS
function! fxns#LessToCss() abort
  let current_file = shellescape(expand('%:p'))
  let filename = shellescape(expand('%:r'))
  let command = 'silent !lessc ' . current_file . ' ' . filename . '.css'
  execute command
endfunction
