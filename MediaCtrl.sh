#!/bin/bash

while [[ 1 = 1 ]] do
	if [[ $1 = 0 ]] then
		input=$(zenity --title="Zug ins Nirgendwo" --question --text="" --ok-label="Pause/Play" --cancel-label="Nächstes Video" --extra-button="Vorheriges Video"  --extra-button="Stop")
		return=$?
		
		if [[ $input = "Vorheriges Video" ]] then
			screen -S PlaylistWorker -X stuff "previous\n"
		elif [[ $input = "Stop" ]] then
			screen -S PlaylistWorker -X stuff "cancel\n"
		fi
		
	else
		zenity --title="Zug ins Nirgendwo" --question --text="" --ok-label="Pause/Play" --cancel-label="Stop"
		return=$?
	fi
		
	if [[ $return = 0 ]] then
		action="pause\n"
	elif [[ $return = 1 ]] then
		action="quit\n"
	fi
	
	
	if [[ $2 = 0 ]] then
		screen -S Stream -X stuff $action
	else
		screen -S Dispaly1 -X stuff $action
		screen -S Dispaly2 -X stuff $action
		screen -S Dispaly3 -X stuff $action
	fi
done

