function fish_prompt --description "Custom fish prompt"
    set -g fish_prompt_pwd_dir_length 0
    set __fish_git_prompt_showupstream informative
    set __fish_git_prompt_char_upstream_prefix " "
    set __fish_git_prompt_showcolorhints 1
    set __fish_git_prompt_use_informative_chars 1
    set __fish_git_prompt_color_upstream red
    set __fish_git_prompt_showdirtystate 1
    set __fish_git_prompt_char_dirtystate '*'

    echo
    if test $VIRTUAL_ENV
        and set -q VIRTUAL_ENV_DISABLE_PROMPT
        set_color 4B8BBE
        echo -n \((basename $VIRTUAL_ENV)\)
        echo -n ' '
        set_color normal
    end


    set -l suffix ' $ '
    set -g color_cwd $fish_color_cwd
    if contains -- $USER root toor
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix ' # '
    end

# If we're running via SSH, change the host color.
    set -l color_host $fish_color_host
    if set -q SSH_TTY
        set color_host $fish_color_host_remote
    end

    if test (string length -V (line_one)) -ge 10
        line_one
        echo
    end

# User
    set_color $fish_color_user --bold
    echo -n $USER
    set_color normal --bold

    echo -n '@'

# Host
    set_color $color_host --bold
    echo -n (prompt_hostname)
    set_color normal --bold
    if test (string length -V (line_one)) -lt 10
        echo -n ': '
        line_one
    end

    echo -n $suffix
end
