#!/bin/bash

# ARGS: Repo directory, [backup folder names]
# TODO: Fix allowing spaces in folder name args

# Globals
LOG_FILE_PATH="/dev/null"
BASE_FOLDER=~/backup_scripts
ARCHIVE_NAME=$(date '+%Y-%b-%d_%H-%M-%S')

# Drive globals
MOUNT_COMMAND_REMOTE="sudo mount -t cifs -o user=,password= //192.168.1.197/Public $BASE_FOLDER/drive_mountpoints/remote"
MOUNT_COMMAND_LOCAL="sudo mount -U "cbc567c3-a7be-4027-80ee-f316eb082a24" $BASE_FOLDER/drive_mountpoints/local"

touch $LOG_FILE_PATH


# Functions
exit_procedure()
{
	# Unmount drives
	sudo umount $BASE_FOLDER/drive_mountpoints/remote
	sudo umount $BASE_FOLDER/drive_mountpoints/local

	# Set local drive to sleep mode (stops spinning)
	printf "Spinning down drive"
	sudo hdparm -y /dev/sda
	exit 1
}


printf "\n$ARCHIVE_NAME Running backup script\n"


# Mount local hdd
printf "Mounting local drive\n"

if ! mountpoint -q "$BASE_FOLDER/drive_mountpoints/local"
then
	eval $MOUNT_COMMAND_LOCAL
	ret_code=$?
	if ! [ $ret_code == 0 ]
	then
		printf "Error, mounting local hdd failed with return code $ret_code exiting...\n"
		exit_procedure
	fi
else
	printf "Local drive is already mounted\n"
fi

LOG_FILE_PATH="$BASE_FOLDER/drive_mountpoints/local/logs/$ARCHIVE_NAME.log"


# Mount network hdd
printf "Mounting remote drive\n"

if ! mountpoint -q "$BASE_FOLDER/drive_mountpoints/remote"
then
	eval $MOUNT_COMMAND_REMOTE &>> $LOG_FILE_PATH
	ret_code=$?
	if ! [ $ret_code == 0 ]
	then
		printf "Error, mounting remote hdd failed with return code $ret_code exiting...\n"
		exit_procedure
	fi
else
	printf "Remote drive is already mounted\n"
fi


REPO_FOLDER_NAME=$(realpath $1)

# Extract backup folders from input args
args_arr=( "$@" )
args_folders="${args_arr[@]:1}"

for folder in $args_folders
do
	BACKUP_FOLDERS+="$(realpath "$folder") "
	printf "Got backup folders $BACKUP_FOLDERS\n"
done
printf "\nGot backup folders $BACKUP_FOLDERS\n"



# Define the passphrase to use for the repo
export BORG_PASSPHRASE=$(cat $BASE_FOLDER/creds.txt)
export BORG_NEW_PASSPHRASE=$(cat $BASE_FOLDER/creds.txt)
printf "Got borg passphrase as "$BORG_PASSPHRASE"\n"

# Create date based archive for repo
printf "\nCreating archive for folder/s$BACKUP_FOLDERS...\n(Writing stats to $LOG_FILE_PATH)\n"
borg create --stats $REPO_FOLDER_NAME::$ARCHIVE_NAME $BACKUP_FOLDERS &>> $LOG_FILE_PATH
if ! [ $? == 0 ]
then
	printf "Failed to create archive $ARCHIVE_NAME\n"
	exit_procedure
fi


# Determine what repos to delete
printf "Pruning repository... \nwriting stats to $LOG_FILE_PATH\n"
borg prune -v --list --stats --keep-within=14d --keep-weekly=4 --keep-monthly=6 --keep-yearly=3 $REPO_FOLDER_NAME &>> $LOG_FILE_PATH
if ! [ $? == 0 ]
then
	printf "Failed to prune repo "$ARCHIVE_NAME" check log in $LOG_FILE_PATH\n"
	exit_procedure
fi

printf "Done\n"
exit_procedure
