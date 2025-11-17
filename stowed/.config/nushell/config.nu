$env.config.show_banner = false
$env.config.buffer_editor = "nvim"

$env.EDITOR = "nvim"

$env.PATH = [
    "~/.local/bin"
    "~/.cargo/bin"
    "~/.gocode/bin"
    "~/.gem/ruby/3.2/bin"
    "~/.gem/ruby/3.0/bin"
    "~/.gem/ruby/2.7/bin"
    "/usr/local/bin"
    "/usr/local/sbin"
    "/usr/bin"
    "/usr/sbin"
    "/bin"
    "/sbin"
]

$env.SXHKD_SHELL = "/bin/sh"

$env.XDG_DATA_HOME   = $"($env.HOME)/.local/share"
$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
$env.XDG_STATE_HOME  = $"($env.HOME)/.local/state"
$env.XDG_CACHE_HOME  = $"($env.HOME)/.cache"

$env.NNN_PLUG = ";:fzplug;z:autojump;p:preview-tui;t:preview-tabbed"
$env.NNN_OPTS = "aAcdu"
$env.NNN_FIFO = "/tmp/nnn.fifo"

$env.FZF_DEFAULT_OPTS = "--no-mouse --color=bw --bind=ctrl-j:accept,ctrl-k:kill-line"

$env.JQ_COLORS = "0;39:0;39:0;39:0;39:0;32:1;39:1;39"

alias cal          = cal --week-start mo
alias parallel     = parallel --will-cite
alias fc-select    = fc-list | sed -r 's/^[^:]+:[ ]+([^,:]+)([,:].*)?/\1/' | sort -u | fzf --layout reverse-list
alias jq-record    = jq '[.d, .s] | transpose | map({(.[1].n): .[0]}) | add'
alias jq-recordset = jq '[.d, [.s]] | combinations | transpose | map({(.[1].n): .[0]}) | add'
alias xml-beautify = xmllint --format --encode utf-8 -
alias theme-toggle = config.clj toggle ~/.config/gtk-3.0/settings.ini Settings gtk-theme-name Adwaita Adwaita-dark
alias theme-light  = config.clj set    ~/.config/gtk-3.0/settings.ini Settings gtk-theme-name Adwaita
alias theme-dark   = config.clj set    ~/.config/gtk-3.0/settings.ini Settings gtk-theme-name Adwaita-dark
alias oil          = nvim -c 'Oil'
alias nrepl        = clj -Sdeps '{:deps {nrepl/nrepl {:mvn/version \"1.3.0\"} cider/cider-nrepl {:mvn/version \"0.50.3\"}}}' -M -m nrepl.cmdline --interactive

$env.PROMPT_COMMAND = {||
    let dir = match (do -i { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)(ansi reset)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

$env.PROMPT_COMMAND_RIGHT = {||

    let username = (whoami   | split row '@' | get 0)
    let hostname = (hostname | split row '.' | get 0)
    let icon_color = (hostname | cut -d '.' -f 1 | md5sum | str substring 0..5)
    let icon = "⯂"

    let tasks_segment = if ((job list | length) > 0) {[
        "["
        (ps
        | where pid in (job list | get pids | each { get 0 } )
        | each { get name | split row "/" | last }
        | enumerate
        | each { [$in.index $in.item] | str join ":" } | str join " ")
        "] "
    ] | str join ""} else { "" }

    let location_segment = ((ansi reset) + $username + (ansi ("#" + $icon_color)) + $icon + (ansi reset) + $hostname)

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        "["
        (ansi rb)
        ($env.LAST_EXIT_CODE)
        (ansi reset)
        "] "
    ] | str join)
    } else { "" }

    [$last_exit_code $tasks_segment $location_segment] | str join
}

$env.config.keybindings ++= [{
    name: unfreeze_job
    modifier: control
    keycode: char_z
    mode: emacs
    event: [
        { edit: Clear }
        {
          edit: InsertString,
          value: "if ((job list | length) > 0) { job unfreeze }"
        }
        { send: Enter }
    ]
}]

source /usr/local/share/examples/nnn/scripts/quitcd/quitcd.nu
source ~/.config/zoxide/zoxide.nu
source ~/.config/atuin/atuin.nu
