function line_one
    set_color $color_cwd --bold
    echo -n (prompt_pwd)
    set_color normal
    echo -n (fish_git_prompt)
end
