#!/bin/bash
CHOICE="$(echo -e "Programs\nRun\nExit\nLock\nShutdown\nRestart" | dmenu -theme material.rasi -icon-theme Papirus-Dark -fn 'Hack-Regular:size=10' -nb '#2e3237' -sb '#2e3237' -nf '#889190' -sf '#dfdfdf ')"
#notify-send $CHOICE
case  $CHOICE  in 
	"Programs")
        rofi -show drun -icon-theme Papirus-Dark -theme material
        ;;
	"Run")
        rofi -show run -icon-theme Papirus-Dark -theme material
        ;;
	"Exit")
		killall xinit
		killall Xsession
        killall awesome
        ;;
	"Lock")
		light-locker-command -l
		;;
	"Shutdown")
		systemctl poweroff
		;;
	"Restart")
		systemctl reboot
		;;
	*)
esac
