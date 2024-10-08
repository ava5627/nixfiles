# My NixOS configuration files

First try at a NixOS configuration

-----

| | |
| --- | --- |
| Window Manager | [qtile](https://github.com/qtile/qtile) |
| Terminal | [kitty](https://github.com/kovidgoyal/kitty) |
| Shell | [fish](https://fishshell.com) |
| Editor | [neovim](https://neovim.io) |
| Browser | [Firefox](https://www.mozilla.org/en-US/firefox/) |
| Launcher | [rofi](https://github.com/davatorium/rofi) |

-----

## Installation

1. Clone this repository
    ```bash
    git clone https://github.com/ava5627/nixfiles ~/nixfiles
    ```
2. Make host configuration and add to `hosts/<hostname>/`
    ```bash
    HOST=$(hostname) # or whatever you want to name the host
    cp /etc/nixos/hardware-configuration.nix ~/nixfiles/hosts/$HOST/hardware-configuration.nix
    cp ./hosts/template ./hosts/$HOST/default.nix
    ```

3. Run installation script
    ```bash
    cd ~/nixfiles
    ./bin/manage.py rebuild --host $HOST
    ```

4. Reboot

-----

## People I stole from

https://github.com/hlissner/dotfiles

https://github.com/ckiee/nixfiles/

https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5
