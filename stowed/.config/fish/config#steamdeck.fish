set PATH \
    $HOME/.local/bin \
    $HOME/.cargo/bin \
    $HOME/.gocode/bin \
    /usr/local/bin \
    /usr/local/sbin \
    /usr/bin \
    /usr/sbin \
    /bin \
    /sbin

alias ls lsd
alias joker "rlwrap $HOME/.local/bin/joker --no-readline"

set os_name (cat /etc/os-release | sed -n '/^NAME=/p' | sed -r 's/^NAME="(.*)"$/\1/')

set xfreerdp (command -v xfreerdp3)
if test -n "$xfreerdp"
    alias xfreerdp "xfreerdp3 \
    +dynamic-resolution       \
    +clipboard                \
    +auto-reconnect           \
    +decorations              \
    /gfx:thin-client          \
"
end

zoxide init fish | source
