setenv LEIN_ROOT 1
setenv SVDIR $HOME/.runit/service
setenv WORKON_HOME $HOME/.virtualenvs
setenv JAVA_CMD /usr/local/openjdk22/bin/java

set PATH \
    $HOME/.local/bin \
    $HOME/.cargo/bin \
    $HOME/.gocode/bin \
    $HOME/.gem/ruby/3.2/bin \
    $HOME/.gem/ruby/3.0/bin \
    $HOME/.gem/ruby/2.7/bin \
    /usr/local/bin \
    /usr/local/sbin \
    /usr/bin \
    /usr/sbin \
    /bin \
    /sbin

alias ls lsd
alias aumix "env LANG=C aumix"
alias mosh "MOSH_ESCAPE_KEY=(printf '\x1f') /usr/local/bin/mosh"
alias hiew 'wineconsole $HOME/.local/opt/hiew/hiew32.exe'
alias joker "rlwrap $HOME/.local/bin/joker --no-readline"

set xfreerdp (command -v xfreerdp3)
if test -n "$xfreerdp"
    alias xfreerdp "xfreerdp3 \
    +clipboard                \
    +auto-reconnect           \
    -decorations              \
    +dynamic-resolution       \
    /audio-mode:1             \
    /bpp:15                   \
    /cache:bitmap:on,glyph:on \
    /compression-level:2      \
    /monitors:1               \
    /window-position:0x0      \
"
end

zoxide init fish | source
