show_application() {
  local index icon color text module

  index=$1
  icon=$(get_tmux_option "@catppuccin_application_icon" "")
  color=$(get_tmux_option "@catppuccin_application_color" "$thm_bg")
  text=$(get_tmux_option "@catppuccin_application_text" "")

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
