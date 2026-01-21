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
    +clipboard                \
    +auto-reconnect           \
    +decorations              \
    +dynamic-resolution       \
    /audio-mode:1             \
    /bpp:16                   \
    /cache:bitmap:on,glyph:on \
    /compression-level:2      \
    /monitors:1               \
"
end

zoxide init fish | source

if test "$os_name" = "Void"
    set -U grc_plugin_execs cat cvs df diff dig gcc g++ ifconfig   \
           make mount mtr netstat ping ps tail traceroute          \
           wdiff blkid du dnf docker docker-compose docker-machine \
           env id ip iostat journalctl kubectl last lsattr lsblk   \
           lspci lsmod lsof getfacl getsebool ulimit uptime nmap   \
           fdisk findmnt free semanage sar ss sysctl systemctl     \
           stat showmount tcpdump tune2fs vmstat w who sockstat

    for executable in $grc_plugin_execs
        if type -q $executable
            function $executable --inherit-variable executable --wraps=$executable
                if isatty 1
                    grc $executable $argv
                else
                    eval command $executable $argv
                end
            end
        end
    end
end
