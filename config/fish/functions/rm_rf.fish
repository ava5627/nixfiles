function rm_rf --description 'Replace rm with rm -rf'
    if not commandline | string length -q
        commandline -r (history search -n 1 -p "rm " | string collect)
    end
    set -l cmd (commandline -p | string collect)
    set -l cmd (string replace -r "rm " "rm -rf " $cmd)
    commandline -r $cmd
end
