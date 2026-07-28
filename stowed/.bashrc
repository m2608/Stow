#
# ~/.bashrc
#

export PATH=$HOME/.local/bin/:$PATH
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

hostname=$(hostnamectl hostname || hostname)
localrc="$XDG_CONFIG_HOME/bash/bashrc#$hostname"

if [ -f "$localrc" ]; then
    source "$localrc"
fi
