" vim:sw=8:ts=8
"
" act like t_Co=0 but use (256) color on just a few things
"

hi clear
if exists("syntax_on")
    syntax reset
endif

let colors_name = "eink"

if !has('gui_running')
  if &background == "light"
    hi Char         cterm=none          ctermbg=none    ctermfg=none
    hi ColorColumn                                      ctermbg=255
    hi Comment      cterm=none          ctermbg=none    ctermfg=240
    hi Conditional  cterm=none          ctermbg=none    ctermfg=none
    hi Constant     cterm=none          ctermbg=none    ctermfg=none
    hi Cursor       cterm=none          ctermbg=214     ctermfg=none
    hi DiffAdd      cterm=none                          ctermfg=none
    hi DiffChange   cterm=none                          ctermfg=none
    hi DiffDelete   cterm=none                          ctermfg=none
    hi DiffText     cterm=reverse                       ctermfg=none
    hi Directive    cterm=none          ctermbg=none    ctermfg=none
    hi Error        cterm=reverse       ctermbg=15      ctermfg=9
    hi ErrorMsg     cterm=reverse       ctermbg=15      ctermfg=9
    hi FoldColumn   cterm=standout                      ctermfg=none
    hi Folded       cterm=standout                      ctermfg=none
    hi Format       cterm=none          ctermbg=none    ctermfg=none
    hi Func         cterm=none          ctermbg=234     ctermfg=250
    hi htmlLink     cterm=none          ctermbg=none    ctermfg=214
    hi Identifier   cterm=none          ctermbg=none    ctermfg=none
    hi Ignore       cterm=none                          ctermfg=none
    hi IncSearch    cterm=reverse       ctermbg=black   ctermfg=214
    hi Keyword      cterm=none          ctermbg=none    ctermfg=none
    hi LineNr       cterm=none                          ctermfg=235
    hi MatchParen   cterm=none          ctermbg=250     ctermfg=none
    hi ModeMsg      cterm=none                          ctermfg=none
    hi MoreMsg      cterm=none                          ctermfg=none
    hi NonText      cterm=none                          ctermfg=235
    hi Normal       cterm=none          ctermbg=white   ctermfg=235
    hi Number       cterm=none          ctermbg=none    ctermfg=none
    hi PreProc      cterm=none                          ctermfg=none
    hi Search       cterm=reverse       ctermbg=black   ctermfg=214
    hi Special      cterm=none          ctermbg=none    ctermfg=none
    hi SpecialKey   cterm=none                          ctermfg=none
    hi Statement    cterm=none          ctermbg=none    ctermfg=none
    hi StatusLine   cterm=none,reverse                  ctermfg=none
    hi StatusLineNC cterm=reverse                       ctermfg=none
    hi String       term=none                           ctermfg=none
    hi Title        cterm=none                          ctermfg=none
    hi Todo         cterm=none,standout ctermbg=0       ctermfg=214
    hi Type         cterm=none          ctermbg=none    ctermfg=none
    hi VertSplit    cterm=reverse                       ctermfg=none
    hi Visual       cterm=reverse                       ctermfg=none
    hi VisualNOS    cterm=none                          ctermfg=none
    hi WarningMsg   cterm=standout                      ctermfg=none
    hi WildMenu     cterm=standout                      ctermfg=none
  else
    hi Char         cterm=none          ctermbg=none    ctermfg=none
    hi ColorColumn                      ctermbg=255
    hi Comment      cterm=none          ctermbg=none    ctermfg=245
    hi Conditional  cterm=none          ctermbg=none    ctermfg=none
    hi Constant     cterm=none          ctermbg=none    ctermfg=none
    hi DiffAdd      cterm=none                          ctermfg=none
    hi DiffChange   cterm=none                          ctermfg=none
    hi DiffDelete   cterm=none                          ctermfg=none
    hi DiffText     cterm=reverse                       ctermfg=none
    hi Directive    cterm=none          ctermbg=none    ctermfg=none
    hi Error        cterm=reverse       ctermbg=15      ctermfg=9
    hi ErrorMsg     cterm=reverse       ctermbg=15      ctermfg=9
    hi FoldColumn   cterm=standout                      ctermfg=none
    hi Folded       cterm=standout                      ctermfg=none
    hi Format       cterm=none          ctermbg=none    ctermfg=none
    hi Func         cterm=none          ctermbg=234     ctermfg=250
    hi htmlLink     cterm=none          ctermbg=none    ctermfg=214
    hi Identifier   cterm=none          ctermbg=none    ctermfg=none
    hi Ignore       cterm=none                          ctermfg=none
    hi IncSearch    cterm=reverse                       ctermfg=214
    hi Keyword      cterm=none          ctermbg=none    ctermfg=none
    hi LineNr       cterm=none                          ctermfg=238
    hi MatchParen   cterm=none          ctermbg=250     ctermfg=none
    hi ModeMsg      cterm=none                          ctermfg=none
    hi MoreMsg      cterm=none                          ctermfg=none
    hi NonText      cterm=none                          ctermfg=238
    hi Normal       cterm=none          ctermbg=234     ctermfg=250
    hi Number       cterm=none          ctermbg=none    ctermfg=none
    hi PreProc      cterm=none                          ctermfg=none
    hi Search       cterm=reverse       ctermbg=black   ctermfg=214
    hi Special      cterm=none          ctermbg=none    ctermfg=none
    hi SpecialKey   cterm=none                          ctermfg=none
    hi Statement    cterm=none          ctermbg=none    ctermfg=none
    hi StatusLine   cterm=none,reverse                  ctermfg=none
    hi StatusLineNC cterm=reverse                       ctermfg=none
    hi String       cterm=none                          ctermfg=none
    hi Title        cterm=none                          ctermfg=none
    hi Todo         cterm=none,standout ctermbg=0       ctermfg=214
    hi Type         cterm=none          ctermbg=none    ctermfg=none
    hi VertSplit    cterm=reverse                       ctermfg=none
    hi Visual       cterm=reverse                       ctermfg=none
    hi VisualNOS    cterm=none                          ctermfg=none
    hi WarningMsg   cterm=standout                      ctermfg=none
    hi WildMenu     cterm=standout                      ctermfg=none
  endif
else
  if &background == "light"
    hi Char         gui=none            guibg=none      guifg=none
    hi ColorColumn                                      guifg=gray60
    hi Comment      gui=none            guibg=none      guifg=gray17
    hi Conditional  gui=none            guibg=none      guifg=none
    hi Constant     gui=none            guibg=none      guifg=none
    hi DiffAdd      gui=none                            guifg=none
    hi DiffChange   gui=none                            guifg=none
    hi DiffDelete   gui=none                            guifg=none
    hi DiffText     gui=reverse                         guifg=none
    hi Directive    gui=none            guibg=none      guifg=none
    hi Error        gui=reverse         guibg=none      guifg=firebrick3
    hi ErrorMsg     gui=reverse         guibg=none      guifg=firebrick3
    hi FoldColumn   gui=standout                        guifg=none
    hi Folded       gui=standout                        guifg=none
    hi Format       gui=none            guibg=none      guifg=none
    hi Func         gui=none            guibg=none      guifg=gray17
    hi Identifier   gui=none            guibg=none      guifg=none
    hi Ignore       gui=none                            guifg=none
    hi IncSearch    gui=reverse                         guifg=none
    hi Keyword      gui=none            guibg=none      guifg=none
    hi LineNr       gui=none                            guifg=gray60
    hi MatchParen   gui=none            guibg=gray70    guifg=none
    hi ModeMsg      gui=none                            guifg=none
    hi MoreMsg      gui=none                            guifg=none
    hi Normal       gui=none            guibg=snow1     guifg=gray11
    hi Number       gui=none            guibg=none      guifg=none
    hi PreProc      gui=none                            guifg=none
    hi Search       gui=reverse                         guifg=none
    hi Special      gui=none       guibg=none      guifg=none
    hi SpecialKey   gui=none                            guifg=none
    hi Statement    gui=none            guibg=none      guifg=none
    hi StatusLine   gui=none,reverse                    guifg=none
    hi StatusLineNC gui=reverse                         guifg=none
    hi String       term=italic                         guifg=none
    hi Title        gui=none                            guifg=none
    hi Todo         gui=none,standout   guibg=none      guifg=darkgoldenrod2
    hi Type         gui=none            guibg=none      guifg=none
    hi VertSplit    gui=reverse                         guifg=none
    hi Visual       gui=reverse                         guifg=none
    hi VisualNOS    gui=none                            guifg=none
    hi WarningMsg   gui=standout                        guifg=none
    hi WildMenu     gui=standout                        guifg=none
  else
    hi Char         gui=none            guibg=none      guifg=none
    hi ColorColumn                      guibg=gray10
    hi Comment      gui=none            guibg=none      guifg=gray50
    hi Conditional  gui=none            guibg=none      guifg=none
    hi Constant     gui=none            guibg=none      guifg=none
    hi DiffAdd      gui=none                            guifg=none
    hi DiffChange   gui=none                            guifg=none
    hi DiffDelete   gui=none                            guifg=none
    hi DiffText     gui=reverse                         guifg=none
    hi Directive    gui=none            guibg=none      guifg=none
    hi Error        gui=reverse         guibg=none      guifg=firebrick3
    hi ErrorMsg     gui=reverse         guibg=none      guifg=firebrick3
    hi FoldColumn   gui=standout                        guifg=none
    hi Folded       gui=standout                        guifg=none
    hi Format       gui=none            guibg=none      guifg=none
    hi Func         gui=none            guibg=none      guifg=gray50
    hi Identifier   gui=none            guibg=none      guifg=none
    hi Ignore       gui=none                            guifg=none
    hi IncSearch    gui=reverse                         guifg=none
    hi Keyword      gui=none            guibg=none      guifg=none
    hi LineNr       gui=none                            guifg=gray30
    hi MatchParen   gui=none            guibg=gray45    guifg=none
    hi ModeMsg      gui=none                            guifg=none
    hi MoreMsg      gui=none                            guifg=none
    hi Normal       gui=none            guibg=#1d1f21   guifg=gray70
    hi Number       gui=none            guibg=none      guifg=none
    hi PreProc      gui=none                            guifg=none
    hi Search       gui=reverse                         guifg=none
    hi Special      gui=none            guibg=none      guifg=none
    hi SpecialKey   gui=none                            guifg=none
    hi Statement    gui=none            guibg=none      guifg=none
    hi StatusLine   gui=none,reverse                    guifg=none
    hi StatusLineNC gui=reverse                         guifg=none
    hi String       gui=italic                          guifg=none
    hi Title        gui=none                            guifg=none
    hi Todo         gui=none,standout   guibg=none      guifg=darkgoldenrod2
    hi Type         gui=none            guibg=none      guifg=none
    hi VertSplit    gui=reverse                         guifg=none
    hi Visual       gui=reverse                         guifg=none
    hi VisualNOS    gui=none                            guifg=none
    hi WarningMsg   gui=standout                        guifg=none
    hi WildMenu     gui=standout                        guifg=none
  endif
endif
