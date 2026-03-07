function fish_user_key_bindings
    bind               ctrl-z "jobs > /dev/null && echo && fg"
    bind --mode insert ctrl-z "jobs > /dev/null && echo && fg"
end
