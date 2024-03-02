#!/usr/bin/env bash

#starting utility applications at boot time
feh --no-fehbg --bg-scale $HOME/Pictures/'Saved Pictures'/Wallpapers/camp_fire.jpg &
blueberry-tray &
solaar -w hide &

#starting user applications at boot time
discord &
steam -silent &
copyq &
kdeconnect-indicator &
morgen --hidden &
# insync start &
firefox &
