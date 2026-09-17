#
# ~/.bashrc
#

export PATH=$HOME/.local/bin/:$PATH
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

export HISTSIZE=-1
export HISTFILESIZE=-1

shopt -s histappend
PROMPT_COMMAND='history -a; history -n'

hostname=$(echo $(command -v hostnamectl > /dev/null && hostnamectl hostname || hostname) | cut -d '.' -f 1)
localrc="$XDG_CONFIG_HOME/bash/bashrc#$hostname"

if [ -f "$localrc" ]; then
    source "$localrc"
fi
