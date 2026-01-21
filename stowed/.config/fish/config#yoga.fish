setenv PAGER nvimpager

alias ls lsd
alias nnn "PAGER='nvimpager -p' "(which nnn)
alias fc-select "fc-list | sed -r 's/^[^:]+:[ ]+([^,:]+)([,:].*)?/\1/' | sort -u | fzf --layout reverse-list"

zoxide init fish | source
