for arg in $argv
    if [ -e "$arg" ]
        set args $args $arg
    else
        set opts $opts $arg
    end
end
if [ -z "$args" ] || [ -d "$args" ]
    lsd $argv
else
  bat $args
end
