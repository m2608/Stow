function _fzf_select_net_iface -d "Select network device."
    set -f ifaces (ip -j link show | jq -r 'map(.ifname) | .[]' | string collect)

    set -f preview_cmd "ip address show dev"

    set -f preview_lines (
        math 1+(echo "$ifaces" | xargs -I{} sh -c "$preview_cmd {} | wc -l" | sort -n | tail -n 1)
    )

    set -f device (
        echo "$ifaces" | _fzf_wrapper --prompt "Iface>" \
            --ansi \
            --preview "$preview_cmd {1}" \
            --preview-window="bottom:$preview_lines:wrap"
    )

    if test $status -eq 0
        commandline --current-token --replace -- $device
    end

    commandline --function repaint
end
