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

setenv PAGER nvimpager

alias ls lsd
alias nnn "PAGER='nvimpager -p' "(which nnn)
alias fc-select "fc-list | sed -r 's/^[^:]+:[ ]+([^,:]+)([,:].*)?/\1/' | sort -u | fzf --layout reverse-list"

zoxide init fish | source
