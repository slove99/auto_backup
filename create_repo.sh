#!/bin/bash

# ARGS: Repo location

# Globals
BASE_FOLDER=~/backup_scripts
REPO_FOLDER_NAME=$(realpath $1)
ARCHIVE_NAME=$(date '+%Y-%b-%d_%H-%M-%S')
LOG_FILE_PATH="BASE_FOLDER/local/logs/"$ARCHIVE_NAME".log"

# Testing borg backup automation within cron script
printf "\"$ARCHIVE_NAME\" Running backup script\n"


# Define the passphrase to use for the repo
export BORG_PASSPHRASE=$(cat ~/backup_scripts/creds.txt)
export BORG_NEW_PASSPHRASE=$(cat ~/backup_scripts/creds.txt)
printf "Got borg passphrase as "$BORG_PASSPHRASE"\n"

# Create repo
printf "Creating repo at $REPO_FOLDER_NAME\n"
borg init --encryption=repokey-blake2 "$REPO_FOLDER_NAME"

# Export repo keys
mkdir -p "$BASE_FOLDER/keys"
borg key export "$REPO_FOLDER_NAME" > ~/backup_scripts/keys/"${REPO_FOLDER_NAME##*/}"
borg key export --paper "$REPO_FOLDER_NAME" > ~/backup_scripts/keys/"${REPO_FOLDER_NAME##*/}".txt
borg key export --qr-html "$REPO_FOLDER_NAME" > ~/backup_scripts/keys/"${REPO_FOLDER_NAME##*/}".html

printf "Done\n"