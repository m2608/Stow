{
    :base {
        :age            {:repo "age"}
        :archivemount   {:repo {:void "fuse-archivemount"}}
        :aria2          {:repo "aria2"}
        :autoconf       {:repo "autoconf"}
        :automake       {:repo "automake"}
        :babashka       {:repo {:void "babashka"}}
        :cargo          {:repo {:void "cargo" :uconsole "cargo"}}
        :clang          {:repo {:void "clang" :uconsole "clang"}}
        :clojure        {:repo "clojure"}
        :clojure-lsp    {:repo {:void "clojure-lsp"}}
        :cmake          {:repo "cmake"}
        :cpio           {:repo {:void "cpio" :uconsole "cpio"}}
        :croc           {:repo {:freebsd "croc" :void "croc"}}
        :curl           {:repo "curl"}
        :epy            {:repo {:freebsd "py311-epy-reader" :void "epy"}}
        :fd             {:repo {:freebsd "fd-find" :void "fd" :uconsole "fd-find"}}
        :fish           {:repo {:freebsd "fish" :void "fish-shell" :uconsole "fish"}}
        :fuse           {:repo "fuse"}
        :fuse3          {:repo {:void "fuse3" :uconsole "fuse3"}}
        :fzf            {:repo "fzf"}
        :gcc            {:repo "gcc"}
        :gdu            {:repo "gdu"}
        :git            {:repo "git"}
        :gnupg          {:repo "gnupg"}
        :grc            {:repo "grc"}
        :gron           {:repo {:freebsd "gron" :void "gron"}}
        :gum            {:repo {:freebsd "gum" :void "gum"}}}}}
        :htop           {:repo "htop"}
        :hurl           {:repo {:freebsd "hurl" :void "hurl"}}
        :janet          {:repo {:freebsd "janet" :void "janet"}
                         :build "janet"}
        :jless          {:repo {:freebsd "jless" :void "jless"}}
        :jpm            {:repo {:freebsd "jpm" :void "jpm"}}
        :jq             {:repo "jq"}
        :lazygit        {:repo {:freebsd "lazygit" :void "lazygit"}}
        :ldns           {:repo {:freebsd "ldns" :void "ldns" :uconsole "ldnsutils"}}
        :lsd            {:repo "lsd"}
        :lsof           {:repo "lsof"}
        :magick         {:repo {:freebsd "ImageMagick7" :void "ImageMagick" :uconsole "imagemagick"}}
        :magic-wormhole {:repo {:freebsd "py311-magic-wormhole" :void "magic-wormhole" :uconsole "magic-wormhole"}}
        :make           {:repo {:freebsd "gmake" :void "make" :uconsole "make"}}
        :mc             {:repo "mc"}
        :mimeinfo       {:repo {:freebsd "p5-File-MimeInfo" :void "perl-File-MimeInfo" :uconsole "libfile-mimeinfo-perl"}}
        :moreutils      {:repo "moreutils"}
        :mpv            {:repo "mpv"}
        :mtr            {:repo {:freebsd "mtr-nox11" :void "mtr" :uconsole "mtr"}}
        :ncurses        {:repo {:freebsd "ncurses" :void "ncurses" :uconsole "ncurses-base"}}
        :neovim         {:repo "neovim"}
        :net-tools      {:repo {:void "net-tools" :uconsole "net-tools"}}
        :nnn            {:repo "nnn"}
        :nvi            {:repo {:void "nvi" :uconsole "nvi"}}
        :nvimpager      {:repo {:freebsd "nvimpager" :void "nvimpager"}}
        :opendoas       {:repo {:freebsd "doas" :void "opendoas" :uconsole "doas"}}
        :p7zip          {:repo {:freebsd "7-zip" :void "p7zip" :uconsole "p7zip"}}
        :pandoc         {:repo {:freebsd "hs-pandoc" :void "pandoc" :uconsole "pandoc"}}
        :patch          {:repo {:void "patch" :uconsole "patch"}}
        :pgcli          {:repo {:freebsd "py311-pgcli" :void "pgcli"}}
        :pkg-config     {:repo {:freebsd "pkgconf" :void "pkg-config" :uconsole "pkg-config"}}
        :pspg           {:repo "pspg"}
        :pv             {:repo "pv"}
        :pyright        {:repo {:freebsd "py311-pyright" :void "pyright"}}
        :rclone         {:repo "rclone"}
        :ripgrep        {:repo "ripgrep"}
        :rlwrap         {:repo "rlwrap"}
        :rsync          {:repo "rsync"}
        :rust           {:repo {:freebsd "rust" :void "rust" :uconsole "rustc"}}
        :sd             {:repo {:freebsd "sd" :void "sd"}}
        :socat          {:repo "socat"}
        :sq             {:repo "sq"}
        :sqlite         {:repo {:freebsd "sqlite3" :void "sqlite" :uconsole "sqlite3"}}
        :stow           {:repo "stow"}
        :strace         {:repo {:void "strace" :uconsole "strace"}}
        :syncthing      {:repo "syncthing"}
        :texlive        {:repo {:freebsd "texlive-full" :void "texlive" :uconsole "texlive"}}
        :tmux           {:repo "tmux"}
        :tree-sitter    {:repo {:freebsd "tree-sitter" :void "tree-sitter"}}
        :unar           {:repo "unar"}
        :unzip          {:repo "unzip"}
        :usql           {:repo {:freebsd "usql" :void "usql"}}
        :uv             {:repo {:freebsd "uv" :void "uv"}}
        :visidata       {:repo {:freebsd "py311-visidata" :void "visidata" :uconsole "visidata"}}
        :vpm            {:repo {:void "vpm"}}
        :xh             {:repo {:freebsd "xh" :void "xh"}}
        :xxd            {:repo "xxd"}
        :yq             {:repo {:freebsd "yq" :void "yq"}}
        :yt-dlp         {:repo {:freebsd "yt-dlp" :void "yt-dlp"}}
        :zoxide         {:repo "zoxide"}
        :zstd           {:repo {:freebsd "zstd" :void "zstd"}}
        }
    :gui {
        :cool-retro-term {:repo "cool-retro-term"}
        :dragon          {:repo {:freebsd "dragon" :void "dragon"}}
        :ffmpeg          {:repo "ffmpeg"}
        :firefox         {:repo {:freebsd "firefox" :void "firefox" :uconsole "firefox-esr"}}
        :freerdp3        {:repo {:freebsd "freerdp3" :void "freerdp3" :uconsole "freerdp2-x11"}}
        :keepassxc       {:repo {:freebsd "keepassxc276" :void "keepassxc" :uconsole "keepassxc"}}
        :libX11-devel    {:repo {:void "libX11-devel" :uconsole "libx11-dev"}}
        :libXft-devel    {:repo {:void "libXft-devel" :uconsole "libxft-dev"}}
        :libXinerama-devel {:repo {:void "libXinerama-devel" :uconsole "libxinerama-dev"}}
        :libreoffice     {:repo "libreoffice"}
        :maim            {:repo "maim"}
        :meld            {:repo "meld"}
        :mpv             {:mpv "mpv"}
        :mupdf           {:repo "mupdf"}
        :nsxiv           {:repo {:freebsd "nsxiv" :void "nsxiv"}}
        :xclip           {:repo "xclip"}
        :xdotool         {:repo "xdotool"}
        :xrdb            {:repo {:freebsd "xrdb" :void "xrdb"}}
        :zathura         {:repo "zathura"}
    }
}
