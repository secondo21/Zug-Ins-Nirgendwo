#!/bin/bash

sleep 0.1

if [ -f ~/.config/vlc/vlc-qt-interface.conf.bak ]; then
    rm ~/.config/vlc/vlc-qt-interface.conf.bak
fi

if [ -f ~/.config/vlc/vlc-qt-interface.conf ]; then
    mv ~/.config/vlc/vlc-qt-interface.conf ~/.config/vlc/vlc-qt-interface.conf.bak
fi

if [[ $1 = 1 ]] then
	if [[ $3 -gt 0 ]] then
		delays=(500 $((500+$3)) $((500+$3*2)))
	else
		delays=($((500-$3*2)) $((500-$3)) 500)
	fi
	
	if [[ $4 = 0 ]] then
		loopingArgument=--repeat
	else
		loopingArgument=--play-and-exit
	fi
	
	echo ${delays[*]}
	screen -dmS Dispaly1 vlc -f --qt-fullscreen-screennumber=1 --network-caching=${delays[0]} --extraintf rc --no-qt-fs-controller --qt-continue --no-video-title-show --no-qt-error-dialogs --no-audio 0 udp://@:1231
	screen -dmS Dispaly2 vlc -f --qt-fullscreen-screennumber=2 --network-caching=${delays[1]} --extraintf rc --no-qt-fs-controller --qt-continue --no-video-title-show --no-qt-error-dialogs 0 udp://@:1232
	screen -dmS Dispaly3 vlc -f --qt-fullscreen-screennumber=3 --network-caching=${delays[2]} --extraintf rc --no-qt-fs-controller --qt-continue --no-video-title-show --no-qt-error-dialogs --no-audio 0 udp://@:1233
	
	screen -dmS Stream cvlc --intf rc --sout "#duplicate{dst=udp{mux=ts,dst=127.0.0.1:1231},dst=udp{mux=ts,dst=127.0.0.1:1232},dst=udp{mux=ts,dst=127.0.0.1:1233}}" $loopingArgument "$2"
	
	while screen -list | grep -q "Stream"
	do
    		sleep 1
	done
	
	screen -S Dispaly1 -X stuff "quit\n"
	screen -S Dispaly2 -X stuff "quit\n"
	screen -S Dispaly3 -X stuff "quit\n"
	
	while screen -list | grep -q "Dispaly*"
	do
    		sleep 1
	done

elif [[ $1 = 3 ]] then

	if [[ $5 = 0 ]] then
		loopingArgument=--repeat
	else
		loopingArgument=--play-and-exit
	fi

	screen -dmS Dispaly1 vlc -f --qt-fullscreen-screennumber=1 --extraintf rc --no-qt-fs-controller --qt-continue 0 --no-video-title-show --no-audio $loopingArgument "$2"
	screen -dmS Dispaly2 vlc -f --qt-fullscreen-screennumber=2 --extraintf rc --no-qt-fs-controller --qt-continue 0 --no-video-title-show $loopingArgument "$3"
	screen -dmS Dispaly3 vlc -f --qt-fullscreen-screennumber=3 --extraintf rc --no-qt-fs-controller --qt-continue 0 --no-video-title-show --no-audio $loopingArgument "$4"
	
	while screen -list | grep -q "Dispaly*"
	do
    		sleep 1
	done
fi

sleep 0.1

if [ -f ~/.config/vlc/vlc-qt-interface.conf ]; then
    rm ~/.config/vlc/vlc-qt-interface.conf
fi

if [ -f ~/.config/vlc/vlc-qt-interface.conf.bak ]; then
    mv ~/.config/vlc/vlc-qt-interface.conf.bak ~/.config/vlc/vlc-qt-interface.conf
fi
