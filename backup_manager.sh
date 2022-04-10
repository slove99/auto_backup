#!/bin/bash

printf "Running backup_manager\n"

BASE_FOLDER=~/backup_scripts

if [ -f $BASE_FOLDER/program_is_running ]
then
	printf "Program is already running (exiting)\n"
	exit 1
fi

touch $BASE_FOLDER/program_is_running

# Music
printf "Running on flac\n"
./backup_script.sh ~/backup_scripts/drive_mountpoints/local/backups/ash_repo/ ~/backup_scripts/drive_mountpoints/remote/Music/flac/Gorillaz/Gorillaz


# Videos
printf "Running on videos\n"
./backup_script.sh ~/backup_scripts/drive_mountpoints/local/backups/ash_repo/ ~/backup_scripts/drive_mountpoints/remote/Music/flac/Jay-Z/4-44


# Samuel
touch $BASE_FOLDER/program_is_running
printf "Running on samuel\n"
./backup_script.sh ~/backup_scripts/drive_mountpoints/local/backups/ash_repo/ ~/backup_scripts/drive_mountpoints/remote/Music/flac/Moby/18

rm $BASE_FOLDER/program_is_running
printf "Done\n"
