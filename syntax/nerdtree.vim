" https://github.com/scrooloose/nerdtree/issues/807
" remove the slashes after each directory node
setlocal conceallevel=3
syntax match NERDTreeDirSlash #/$# containedin=NERDTreeDir conceal contained

function! s:get_color(group, attr) abort
  return synIDattr(synIDtrans(hlID(a:group)), a:attr)
endfunction

function! s:get_attrs(group) abort
  let fg = s:get_color(a:group, 'fg')
  if empty(fg)
    let fg = s:get_color('Normal', 'fg')
  endif
  return printf('%sbg=%s %sfg=%s', s:gui_or_cterm, s:normal_bg, s:gui_or_cterm, fg)
endfunction

let s:use_gui = has('gui_running') || (has('termguicolors') && &termguicolors)
let s:gui_or_cterm = s:use_gui ? 'gui' : 'cterm'
let s:normal_bg = s:get_color('Normal', 'bg')
if empty(s:normal_bg)
  let s:normal_bg = 'NONE'
endif

let s:hl_group = {
      \ 'Comment':     [ 'Constant',       [ 'md',  'MD', 'org', 'txt'                               ]  ] ,
      \ 'Character':   [ 'Number',         [ 'png', 'svg', 'jpg', 'bmp', 'gif'                       ]  ] ,
      \ 'Number':      [ 'Float',          [ 'sass', 'scss', 'css', 'less', 'coffee'                 ]  ] ,
      \ 'Float':       [ 'Identifier',     [ 'sh', 'ps1', 'bat', 'cmd'                               ]  ] ,
      \ 'Identifier':  [ 'Function',       [ 'vim', 'swift', 'dart'                                  ]  ] ,
      \ 'Function':    [ 'Statement',      [ 'html', 'ts', 'vue', 'js', 'jsx', 'ts'                  ]  ] ,
      \ 'Statement':   [ 'Label',          [ 'py', 'pyc', 'pyo', 'rb', 'php', 'lua'                  ]  ] ,
      \ 'Label':       [ 'Operator',       [ 'hs', 'go', 'java', 'rs'                                ]  ] ,
      \ 'Boolean':     [ 'Include',        [ 'cpp', 'cc', 'hpp', 'cxx', 'hxx', 'h'                   ]  ] ,
      \ 'Delimiter':   [ 'Macro',          [ 'docs', 'doc', 'cnx', 'pdf'                             ]  ] ,
      \ 'Constant':    [ 'SpecialComment', [ 'ignore', 'editorconfig', 'gitconfig', 'gitattributes'  ]  ] ,
      \ 'String':      [ 'SpecialComment', [ 'toml', 'yml', 'ini', 'info', 'conf', 'yaml', 'json'    ]  ] ,
      \ 'Operator':    [ 'SpecialComment', [ 'rc', 'lesshst'                                         ]  ] ,
      \ 'PreCondit':   [ 'SpecialComment', [ 'profile', 'zshenv'                                     ]  ] ,
      \ 'Include':     [ 'SpecialComment', [ 'history', 'vimsize', 'wasm'                            ]  ] ,
      \ 'Conditional': [ 'SpecialComment', [ 'log', 'tags'                                           ]  ] ,
      \ 'SpecialKey':  [ 'SpecialComment', [ 'lock'                                                  ]  ] ,
      \ 'PreProc':     [ 'SpecialComment', [ 'LICENSE', 'AUTHOR',                                    ]  ] ,
      \ 'TypeDef':     [ 'SpecialComment', [ 'Makefile', 'Dockerfile'                                ]  ] ,
      \ }

function! s:apply_highlight(extension, group, ext_hl_group)
  let ext_group_name = 'NERDTreeDash_'.a:extension
  execute 'syntax match' ext_group_name '/\f*'.a:extension.'$/'
  execute 'syntax match' a:extension    '/^\s\+.*'.a:extension.'$/' 'contains='.ext_group_name

  execute 'hi!' a:extension    s:get_attrs(a:group)
  execute 'hi!' ext_group_name s:get_attrs(a:ext_hl_group)
endfunction

function! s:add_highlight() abort
  for [group, exts] in items(s:hl_group)
    let [ext_hl_group, exts] = [exts[0], exts[1]]
    call map(exts, 's:apply_highlight(v:val, group, ext_hl_group)')
  endfor
endfunction

call s:add_highlight()

augroup NERDTreeDash
  autocmd!
  autocmd ColorScheme * call <SID>add_highlight()
augroup END
