fish_add_path $HOME/.local/bin $HOME/.cargo/bin

setenv EDITOR nvim
setenv NVIM_GTK_NO_HEADERBAR 1
setenv NNN_PLUG ";:fzplug;z:autojump;p:preview-tui;t:preview-tabbed"
setenv NNN_OPTS "aAcdu"
setenv NNN_FIFO "/tmp/nnn.fifo"
setenv FZF_DEFAULT_OPTS "--no-mouse --color=bw --bind=ctrl-j:accept,ctrl-k:kill-line"
setenv JQ_COLORS "0;39:0;39:0;39:0;39:0;32:1;39:1;39"

setenv XDG_DATA_HOME   $HOME/.local/share
setenv XDG_CONFIG_HOME $HOME/.config
setenv XDG_STATE_HOME  $HOME/.local/state
setenv XDG_CACHE_HOME  $HOME/.cache

bind \cz "jobs > /dev/null && echo && fg"

alias cal "cal -M"
alias parallel "parallel --will-cite"
alias fc-select "fc-list | sed -r 's/^[^:]+:[ ]+([^,:]+)([,:].*)?/\1/' | sort -u | fzf --layout reverse-list"
alias jq-record "jq '[.d, .s] | transpose | map({(.[1].n): .[0]}) | add'"
alias jq-recordset "jq '[.d, [.s]] | combinations | transpose | map({(.[1].n): .[0]}) | add'"
alias xml-beautify 'xmllint --format --encode utf-8 -'

alias theme-toggle 'config.clj toggle ~/.config/gtk-3.0/settings.ini Settings gtk-theme-name Adwaita Adwaita-dark'
alias theme-light  'config.clj set    ~/.config/gtk-3.0/settings.ini Settings gtk-theme-name Adwaita'
alias theme-dark   'config.clj set    ~/.config/gtk-3.0/settings.ini Settings gtk-theme-name Adwaita-dark'

set nnn (which nnn)
if test -n "$nnn"
    alias nnn "LANG=ru_RU.UTF-8 PAGER='nvimpager -p' NO_COLOR=1 $nnn"
end
alias oil "nvim -c 'Oil'"
alias nrepl "clj -Sdeps '{:deps {nrepl/nrepl {:mvn/version \"1.3.0\"} cider/cider-nrepl {:mvn/version \"0.50.3\"}}}' -M -m nrepl.cmdline --interactive"


set host_config (status dirname)"$fold_config/config.fish#"(hostname | sed 's/\..*//')

if test -e "$host_config"
    source "$host_config"
end
