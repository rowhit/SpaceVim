let s:logger_level = g:spacevim_debug_level
let s:levels = ['Info', 'Warn', 'Error']
let s:logger_file = expand('~/.SpaceVim/.SpaceVim.log')

""
" @public
" Set debug level of SpaceVim, by default it is 1. all message will be logged.
"
"     1 : log all the message.
"
"     2 : log warning and error message
"
"     3 : log error message only
function! SpaceVim#logger#setLevel(level) abort
    let s:logger_level = a:level
endfunction

function! SpaceVim#logger#info(msg) abort
    if g:spacevim_enable_debug && s:logger_level <= 1
        call s:wite(s:warpMsg(a:msg, 1))
    endif
endfunction

function! SpaceVim#logger#warn(msg) abort
    if g:spacevim_enable_debug && s:logger_level <= 2
        call s:wite(s:warpMsg(a:msg, 2))
    endif
endfunction

function! SpaceVim#logger#error(msg) abort
    if g:spacevim_enable_debug && s:logger_level <= 3
        call s:wite(s:warpMsg(a:msg, 3))
    endif
endfunction

function! s:wite(msg) abort
    let flags = filewritable(s:logger_file) ? 'a' : ''
    call writefile([a:msg], s:logger_file, flags)
endfunction


function! SpaceVim#logger#viewLog(...) abort
    let l = a:0 > 0 ? a:1 : 1
    let logs = readfile(s:logger_file, '')
    echo logs[0]
    return join(filter(logs, "v:val =~# '\[ SpaceVim \] \[\d\d\:\d\d\:\d\d\] \[" . s:levels[l] . "\]'"), "\n")
endfunction

""
" @public
" Set log output file of SpaceVim. by default it is
" `~/.SpaceVim/.SpaceVim.log`
function! SpaceVim#logger#setOutput(file) abort
    let s:logger_file = a:file
endfunction

function! s:warpMsg(msg,l) abort
    let time = strftime('%H:%M:%S')
    let log = '[ SpaceVim ] [' . time . '] [' . s:levels[a:l - 1] . '] ' . a:msg
    return log
endfunction

function! SpaceVim#logger#echoWarn(msg) abort
    echohl WarningMsg
    echom s:warpMsg(a:msg, 1)
    echohl None
endfunction
