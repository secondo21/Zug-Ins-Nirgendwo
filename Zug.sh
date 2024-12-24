#!/bin/bash

mode=$(zenity --title="Zug ins Nirgendwo" --info --text="Bitte wälen sie den Modus" --ok-label="1 Video" --extra-button="3 Videos"  --extra-button="Playlist")
return=$?
if [[ $return = 0 ]] then 
	mode="1 Video" 
	
	zenity --title="Zug ins Nirgendwo" --question --text="soll das video in dauerschleife laufen" --ok-label="Ja" --cancel-label="Nein"
	loop=$?
	
	while [[ $file != *.mp4 ]] do
		file=$(zenity --title="Zug ins Nirgendwo" --file-selection --text="Wähle ein video" --file-filter='mp4 Video | *.mp4')
	done
	
	while [[ $delayIsNumber != 1 ]] do
	
		delay=$(zenity --title="Zug ins Nirgendwo" --entry --text="Gebe die Verzögerung zwischen den Displays in Millisekunden ein. bei negetiven Werten wird die Verzögerung gedreht")
		
		if [[ $delay =~ ^[+-]?[0-9]+$ ]]; then
			delayIsNumber=1
		else
			zenity --title="Zug ins Nirgendwo" --error --text="Der eingegebene Wert muss eine ganze Zahl sein"
		fi
	done
	screen -dmS MediaCtrl ~/Zug-Ins-Nirgendwo/MediaCtrl.sh 1 0
	~/Zug-Ins-Nirgendwo/PlayVideo.sh 1 "$file" $delay $loop
	screen -S MediaCtrl -X stuff "^C"
else
	
	zenity --title="Zug ins Nirgendwo" --question --text="Sollen die videos in dauerschleife laufen?" --ok-label="Ja" --cancel-label="Nein"
	loop=$?
	
	if [[ $mode = "Playlist" ]] then 
		
		while [[ $file != *.play ]] do
			file=$(zenity --title="Zug ins Nirgendwo" --file-selection --text="Wähle die Paylist" --file-filter='Playlist | *.play')
		done
		screen -dmS PlaylistWorker ~/Zug-Ins-Nirgendwo/PlaylistWorker.sh $file $loop
		while screen -list | grep -q "PlaylistWorker"
		do
    			sleep 1
		done
		
	else
		VideoNumber=1
		while [[ $VideoNumber -le 3 ]] do
			while [[ $file != *.mp4 ]] do
				file=$(zenity --title="Zug ins Nirgendwo" --file-selection --text="Wähle ein video für Display $VideoNumber" --file-filter='mp4 Video | *.mp4')
				echo $VideoNumber
			done
			Videos+=($file)
			VideoNumber=$(($VideoNumber+1))
			file="error"
		done
		screen -dmS MediaCtrl ~/Zug-Ins-Nirgendwo/MediaCtrl.sh 1 1
		~/Zug-Ins-Nirgendwo/PlayVideo.sh 3 "${Videos[0]}" "${Videos[1]}" "${Videos[2]}" $loop
		screen -S MediaCtrl -X stuff "^C"
	fi
fi
