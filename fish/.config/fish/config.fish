set host_config (status dirname)"$fold_config/config.fish#"(hostname)

if test -e "$host_config"
    source "$host_config"
end
