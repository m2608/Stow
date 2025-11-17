fish_add_path $HOME/.local/bin $HOME/.cargo/bin

setenv EDITOR (command -v nvim)

setenv FZF_DEFAULT_OPTS "--no-mouse --color=bw --bind=ctrl-j:accept,ctrl-k:kill-line"

setenv JQ_COLORS "0;39:0;39:0;39:0;39:0;32:1;39:1;39"

setenv GOPATH $HOME/.gocode

setenv XDG_DATA_HOME   $HOME/.local/share
setenv XDG_CONFIG_HOME $HOME/.config
setenv XDG_STATE_HOME  $HOME/.local/state
setenv XDG_CACHE_HOME  $HOME/.cache

# Some terminals (mc) do not support sequences which fish uses by default. 
# https://github.com/fish-shell/fish-shell/issues/11427
# set -a fish_features no-keyboard-protocols
set -g fish_greeting ""

bind ctrl-z "jobs > /dev/null && echo && fg"

if string match -q -e freebsd (status buildinfo)
    alias cal "cal -M"
else
    alias cal "cal -m"
end

alias parallel     "parallel --will-cite"
alias fc-select    "fc-list | sed -r 's/^[^:]+:[ ]+([^,:]+)([,:].*)?/\1/' | sort -u | fzf --layout reverse-list"
alias jq-record    "jq '[.d, .s] | transpose | map({(.[1].n): .[0]}) | add'"
alias jq-recordset "jq '[.d, [.s]] | combinations | transpose | map({(.[1].n): .[0]}) | add'"
alias xml-beautify "xmllint --format --encode utf-8 -"
alias urlencode    "jq -Rr '@uri'"
alias theme-toggle "config.clj toggle ~/.config/gtk-3.0/settings.ini Settings gtk-theme-name Adwaita Adwaita-dark"
alias theme-light  "config.clj set    ~/.config/gtk-3.0/settings.ini Settings gtk-theme-name Adwaita"
alias theme-dark   "config.clj set    ~/.config/gtk-3.0/settings.ini Settings gtk-theme-name Adwaita-dark"
alias ssh-kh       "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# Let's set some variables for nnn.
set cmd (command -v nnn)
if test -n "$cmd"
    setenv NNN_PLUG ";:fzplug;z:autojump;p:preview-tui;t:preview-tabbed;d:dragdrop;c:rsynccp;e:suedit"
    setenv NNN_OPTS "aAcdu"
    setenv NNN_FIFO "/tmp/nnn.fifo"
    setenv NNN_PREVIEWIMGPROG $HOME/.local/bin/show-sixel.sh

    alias nnn "LANG=ru_RU.UTF-8 PAGER='nvimpager -p' NO_COLOR=1 $cmd"
end

# Lazygit requires basename to be set in $EDITOR variable.
set cmd (command -v lazygit)
if test -n "$cmd"
    alias lazygit "env EDITOR="(path basename $EDITOR)" $cmd"
end

alias oil "nvim -c 'Oil'"
alias nrepl "clj -Sdeps '{:deps {nrepl/nrepl {:mvn/version \"1.3.0\"} cider/cider-nrepl {:mvn/version \"0.50.3\"}}}' -M -m nrepl.cmdline --interactive"

set short_hostname (string replace -r '[.].*' '' $hostname)
set current_dir (status dirname)
set host_config "$current_dir/config.fish#$short_hostname"

if test -e "$host_config"
    source "$host_config"
end
