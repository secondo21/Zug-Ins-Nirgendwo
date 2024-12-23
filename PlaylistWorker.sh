#!/bin/bash

line=1
running=1

while [[ $running = 1 ]]; do

	command=$(sed -n ${line}p "$1")
	echo $command
	
	if [ -z "$command" ]; then
	
		if [[ $2 = 0 ]]; then 
			line=1
		else
			running=0
		fi
		
	else
	
		if [ ${command:0:1} == "3" ]; then
			screen -dmS MediaCtrl ~/Zug-ins-Nirgendwo/MediaCtrl.sh 0 1
		else
			screen -dmS MediaCtrl ~/Zug-ins-Nirgendwo/MediaCtrl.sh 0 0
		fi
		~/Zug-ins-Nirgendwo/PlayVideo.sh $command 1
		screen -S MediaCtrl -X stuff "^C"
		line=$((line+1))
	fi
	
	read -t 0.1 mediaCtrl
    
	if [[ "$mediaCtrl" == "previous" ]]; then
	
		if [[ $line -le 2 ]]; then
			line=1
		else
			line=$((line-2))
		fi
		
	elif [[ "$mediaCtrl" == "cancel" ]]; then
		running=0
	fi
	echo "$line"
done
