set PATH $HOME/.local/bin $HOME/.cargo/bin $PATH

setenv EDITOR nvim
setenv NNN_PLUG "f:finder;c:fzcd;p:preview-tui;z:autojump"
setenv NNN_OPTS "aAcCdu"

set host_config (status dirname)"$fold_config/config.fish#"(hostname | sed 's/\..*//')

if test -e "$host_config"
    source "$host_config"
end
