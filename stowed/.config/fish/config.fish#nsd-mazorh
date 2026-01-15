setenv LC_COLLATE C

set PATH \
    $GOPATH/bin \
    $HOME/.local/opt/go/bin/ \
    $HOME/.cargo/bin \
    $HOME/.local/bin \
    /opt/Tensor/Saby \
    /usr/local/bin \
    /usr/local/sbin \
    /usr/bin \
    /usr/sbin \
    /bin \
    /sbin

set os_name (cat /etc/os-release | sed -n '/^NAME=/p' | sed -r 's/^NAME="(.*)"$/\1/')
if test "$os_name" = "Red Hat Enterprise Linux"
    set PATH "$HOME/.local/bin.rh:$PATH"
else if test "$os_name" = "Void"
    setenv NODE_PATH (npm root -g)
    set PATH "$HOME/.local/bin.void:$HOME/.npm-global/bin:$PATH"
end

setenv NNN_ARCHMNT ratarmount
setenv VAULT_ADDR "https://csr-vault.sbis.ru"

alias less 'less -r'
alias ls lsd
# alias vimj 'vim -c "ru macros/justify.vim" -c "normal gqG" -c "normal gg" -c "normal _j" -c "set nonumber" -'
alias mvi='mpv --config-dir=$HOME/.config/mvi'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias ch "clickhouse local"
# alias alacritty "MESA_GL_VERSION_OVERRIDE=3.3 $HOME/.cargo/bin/alacritty"
# alias hiew 'wineconsole $HOME/.local/opt/hiew32demo/hiew32demo.exe'

abbr hurl-proxy "hurl --proxy socks://127.0.0.1:5555"

zoxide init fish | source
