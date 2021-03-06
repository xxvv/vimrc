
if has('win32')
  if has('nvim')
    let $VIMFILES=expand('$USERPROFILE/AppData/Local/nvim')
  else
    let $VIMFILES=expand('$VIM/vimfiles')
  endif
else
  let $VIMFILES=expand('~/.vim')
endif

if has('win32')
  let $PATH=$PATH.";".expand('$VIMFILES/tools')
else
  let $PATH=$PATH.":".expand('$VIMFILES/tools')
endif

source $VIMFILES/plugged.vim
source $VIMFILES/amix.vim
source $VIMFILES/wwcd.vim

" vim: ts=2 sw=2 et
