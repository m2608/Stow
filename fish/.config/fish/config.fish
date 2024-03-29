fish_add_path $HOME/.local/bin $HOME/.cargo/bin

setenv EDITOR nvim
setenv NVIM_GTK_NO_HEADERBAR 1
setenv NNN_PLUG "f:finder;c:fzcd;p:preview-tui;z:autojump"
setenv NNN_OPTS "aAcCdu"

setenv JQ_COLORS "0;39:0;39:0;39:0;39:0;32:1;39:1;39"

bind \cz "jobs > /dev/null && fg"

set host_config (status dirname)"$fold_config/config.fish#"(hostname | sed 's/\..*//')

if test -e "$host_config"
    source "$host_config"
end
