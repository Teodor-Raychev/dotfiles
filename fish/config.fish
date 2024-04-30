if status is-interactive
    # Commands to run in interactive sessions can go here
    # enter private mode: fish -P
    # Theme tide (powerlevel based)
    # fisher install IlanCosman/tide@v6
    set -g tide_git_color_branch 5E5E5E
    set -g tide_character_color 906CEB
    set -g tide_shlvl_color 5E5E5E
    set -g tide_ruby_color 5E5E5E
    set -g tide_node_color 5E5E5E
    set -g tide_python_color 5E5E5E
    set -g tide_git_truncation_length 24
    set -g tide_git_color_untracked 5E5E5E
    set -g tide_git_color_stash 5E5E5E
    set -g tide_git_color_staged 5E5E5E
    set -g tide_git_bg_color 5E5E5E
    # set the main line:
    set -g tide_left_prompt_items private_mode pwd context character
    set -g tide_right_prompt_frame_enabled true
    set -g tide_right_prompt_items cmd_duration status ruby python node rustc java go kubectl zig git
    # emulate vim cursor:
    fish_vi_key_bindings
    set -g fish_cursor_default block
    set -g fish_cursor_insert block blink
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_visual block
    # restore default behaviour
    # fish_default_key_bindings
end
