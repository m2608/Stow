fish_add_path $HOME/.local/bin $HOME/.cargo/bin

setenv EDITOR nvim
setenv NVIM_GTK_NO_HEADERBAR 1
setenv NNN_PLUG ";:fzplug;z:autojump;p:preview-tui;t:preview-tabbed"
setenv NNN_OPTS "aAcdu"
setenv NNN_FIFO "/tmp/nnn.fifo"

setenv JQ_COLORS "0;39:0;39:0;39:0;39:0;32:1;39:1;39"

bind \cz "jobs > /dev/null && echo && fg"

alias fc-select "fc-list | sed -r 's/^[^:]+:[ ]+([^,:]+)([,:].*)?/\1/' | sort -u | fzf --layout reverse-list"

set nnn (which nnn)
if test -n "$nnn"
    alias nnn "LANG=ru_RU.UTF-8 PAGER='nvimpager -p' NO_COLOR=1 $nnn"
end
alias oil "nvim -c 'Oil'"

set host_config (status dirname)"$fold_config/config.fish#"(hostname | sed 's/\..*//')

if test -e "$host_config"
    source "$host_config"
end
