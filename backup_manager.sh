#!/bin/bash

printf "Running backup_manager\n"

BASE_FOLDER=~/backup_scripts

if [ -f $BASE_FOLDER/program_is_running ]
then
	printf "Program is already running (exiting)\n"
	exit 1
fi

touch $BASE_FOLDER/program_is_running

# Samuel
printf "Running on samuel\n"
$BASE_FOLDER/backup_script.sh $BASE_FOLDER/drive_mountpoints/local/backups/repo_samuel/ $BASE_FOLDER/drive_mountpoints/remote/Samuel
printf "Completed backup for samuel\n"

# Music
printf "Running on flac\n"
$BASE_FOLDER/backup_script.sh $BASE_FOLDER/drive_mountpoints/local/backups/repo_flac/ $BASE_FOLDER/drive_mountpoints/remote/Music/flac
printf "Completed backup for flac\n"

# Videos
printf "Running on videos\n"
$BASE_FOLDER/backup_script.sh $BASE_FOLDER/drive_mountpoints/local/backups/repo_videos/ $BASE_FOLDER/drive_mountpoints/remote/Videos
printf "Completed backup for Videos\n"

# Study_pc
printf "Running on study_pc\n"
$BASE_FOLDER/backup_script.sh $BASE_FOLDER/drive_mountpoints/local/backups/repo_pc_study $BASE_FOLDER/drive_mountpoints/remote/pc_backups/study_pc_2022
printf "Completed backup for study_pc\n"

# Study_pc_old
printf "Running on old_study_pc\n"
$BASE_FOLDER/backup_script.sh $BASE_FOLDER/drive_mountpoints/local/backups/repo_old_pc_study $BASE_FOLDER/drive_mountpoints/remote/pc_backups/study_pc_old
printf "Completed backup for old_study_pc\n"

rm $BASE_FOLDER/program_is_running
printf "Done\n"
