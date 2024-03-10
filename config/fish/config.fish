set fish_greeting                                 # Supresses fish's intro message

set fish_color_host $fish_color_user
set fish_color_cwd magenta #$fish_color_param
set -g fish_prompt_pwd_dir_length 0

if set -q VIRTUAL_ENV && contains $VIRTUAL_ENV/bin $PATH
    set index (contains -i $VIRTUAL_ENV/bin $PATH)
    set -ge PATH[$index]
    set -gxp PATH $VIRTUAL_ENV/bin
end

bind \cq kill-whole-line

set __fish_git_prompt_showupstream informative
set __fish_git_prompt_char_upstream_prefix " "
set __fish_git_prompt_showcolorhints 1
set __fish_git_prompt_use_informative_chars 1
set __fish_git_prompt_color_upstream red
set __fish_git_prompt_showdirtystate 1
set __fish_git_prompt_char_dirtystate '*'
