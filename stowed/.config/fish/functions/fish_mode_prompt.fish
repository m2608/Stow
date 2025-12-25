function fish_mode_prompt
  set -l mark ""
  set -l back "black"

  switch $fish_bind_mode
    case default
      set back blue
      set mark "ℕ"
    case insert
      set back green
      set mark '𝕀'
    case replace_one
      set back green
      set mark 'ℝ'
    case replace
      set back yellow
      set mark 'ℝ'
    case visual
      set back magenta
      set mark '𝕍'
  end

  echo -n -s (set_color brwhite) (set_color -b $back) " $mark " (set_color -b black) (set_color normal) " "
end
