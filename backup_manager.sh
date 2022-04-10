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
./backup_script.sh $BASE_FOLDER/drive_mountpoints/local/backups/repo_flac/ $BASE_FOLDER/drive_mountpoints/remote/Music/flac


# Videos
printf "Running on videos\n"
./backup_script.sh $BASE_FOLDER/drive_mountpoints/local/backups/repo_videos/ $BASE_FOLDER/drive_mountpoints/remote/Videos


# Samuel
touch $BASE_FOLDER/program_is_running
printf "Running on samuel\n"
./backup_script.sh $BASE_FOLDER/drive_mountpoints/local/backups/repo_samuel/ $BASE_FOLDER/drive_mountpoints/remote/Samuel

rm $BASE_FOLDER/program_is_running
printf "Done\n"
