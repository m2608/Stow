function format_jobs -d "Format jobs list for prompt"
    set -l color_norm "$argv[1]"
    set -l color_jobs "$argv[2]"

    set -l jobs
    for job in (jobs | sort -n)
        set -l job_info (string split (printf "\t") "$job")

        set -l job_number $job_info[1]
        set -l job_command (string split --fields 1 " " $job_info[-1])

        set --append jobs "$color_norm$job_number:$color_jobs$job_command$color_norm"
    end

    if test -n "$jobs"
        echo " ["(string join " " $jobs)"]"
    else
        echo ""
    end
end

function format_duration -d "Format duration (in milliseconds)"
    set duration $argv[1]
    set duration_list

    for pairs in "1000 ms" "60 s" "60 m" "24 h"
        set pair (string split " " $pairs)

        set divider $pair[1]
        set unit $pair[2]

        set --prepend duration_list (math "$duration % $divider")$unit
        set duration (math "floor($duration / $divider)")

        if test $duration -eq 0
            break
        end
    end

    if test $duration -gt 0
        set --prepend duration_list "$duration"d
    end

    echo $duration_list[1..2]
end

function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l normal (set_color normal)
    set -q fish_color_status
    or set -g fish_color_status --background=red white

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix '>'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # Write pipestatus
    # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color $bold_flag $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

    # List of jobs (if any)
    set -l jobs (format_jobs "$normal" (set_color $fish_color_quote))

    # Last command execution time.
    set -l duration (format_duration $CMD_DURATION)

    # Username.
    set -l user (set_color $fish_color_user)(whoami | cut -d '@' -f 1)

    # Hostname icon and color.
    set -l color_host (hostname | cut -d '.' -f 1 | md5sum | cut -c 1-6)
    set icon (set_color $color_host)(printf "⯂")
    set host (set_color $fish_color_host)(hostname | cut -d '.' -f 1)

    echo -n -s $user $icon $host ' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal $jobs " "[$duration] " "$prompt_status $suffix " "
end
