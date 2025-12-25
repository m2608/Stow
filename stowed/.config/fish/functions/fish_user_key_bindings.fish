function fish_user_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert

    bind               ctrl-z "jobs > /dev/null && echo && fg"
    bind --mode insert ctrl-z "jobs > /dev/null && echo && fg"
end
