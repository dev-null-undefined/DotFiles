#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

style="$($HOME/.config/rofi/applets/menu/style.sh)"

dir="$HOME/.config/rofi/applets/menu/configs/$style"
rofi_command="rofi -theme $dir/powermenu.rasi"

uptime=$(uptime | sed -e 's/up .*//g')
cpu=$($HOME/.config/rofi/bin/usedcpu)
memory=$($HOME/.config/rofi/bin/usedram)

# Options
shutdown=""
reboot=""
lock=""
suspend=""
arandr=""
audio=" 墳"


# Confirmation
confirm_exit() {
	echo -e "Yes\nNo" | rofi -dmenu\
		-p "Are You Sure? : "\
		-theme $dir/powermenu.rasi
}

# Message
msg() {
    	exit 0
	rofi -theme "$HOME/.config/rofi/applets/styles/message.rasi" -e "Available Options  -  yes / y / no / n"
}

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$arandr$audio"
chosen="$(echo -e "$options" | $rofi_command -p "祥  $uptime  |     $cpu  |  ﬙  $memory " -dmenu -selected-row 2)"
echo "$chosen"
case $chosen in
    $shutdown)
		ans=$(confirm_exit &)
		if [[ $ans == "Yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			systemctl poweroff
		elif [[ $ans == "No" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $reboot)
		ans=$(confirm_exit &)
		if [[ $ans == "Yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			systemctl reboot
		elif [[ $ans == "No" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $lock)
		slock
        ;;
    $suspend)
		ans=$(confirm_exit &)
		echo $ans
		if [[ $ans == "Yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			mpc -q pause
			amixer set Master mute
			slock systemctl hibernate
		elif [[ $ans == "No" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $arandr$audio)
		autorandr --change
		/home/martin/GitHub/Martin/DotFiles/scripts/audio-devices 
	;;
esac
