function lb --description='ls if arg is a directory, otherwise print file with bat' --wraps="eza"
    for arg in $argv
        if [ -e "$arg" ]
            set args $args $arg
        else
            set opts $opts $arg
        end
    end
    if [ -z "$args" ] || [ -d "$args" ]
        eza $argv
    else
      bat $args
    end
end
