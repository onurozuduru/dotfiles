#!/bin/bash
###############################################################################
#File: backup_nvim.sh
#
#License: MIT
#
#Copyright (C) 2024 Onur Ozuduru
#
#Follow Me!
#  github: github.com/onurozuduru
###############################################################################

BACKUP_DIR="${HOME}/nvim_backups"

print_help() {
    echo "Usage: $0 [ -b|--backup-dir <DIR> ] [-h]"
    # Definition of the script.
    echo -e "Backup nvim config and other folders."
    echo -e "\t-h,--help\tDisplay help."
    echo -e "\t-b,--backup-dir\t\tBackup directory path. Default: ${BACKUP_DIR}"
}

## Takes file path, renames to reflect its path then moves to backup directory.
# File path needs to be relative to $HOME
rename_move_file() {
    local file_path="$1"

    # Replace all: '/' -> '-'
    local backup_file="${BACKUP_DIR}/${file_path//\//-}.bak"
    file_path="${HOME}/${file_path}"

    if [[ -e "${file_path}" ]]; then
        echo "Moving: ${file_path} -> ${backup_file}"
        mv "${file_path}" "${backup_file}"
    else
        echo "Could not find: ${file_path}"
    fi
}

backup_nvim() {
    mkdir -p "${BACKUP_DIR}"
    rename_move_file .local/share/nvim
    rename_move_file .local/state/nvim
    rename_move_file .cache/nvim
    rename_move_file .config/nvim
}

set -e
params=$(getopt -l "help,backup-dir:" -o "hb:" -- "$@")

eval set -- "$params"

while true
do
    case $1 in
        -h|--help)
            print_help
            exit 0
            ;;
        -b|--backup-dir)
            shift
            BACKUP_DIR="$1"
            ;;
        --)
            shift
            break ;;
        *)
            print_help
            exit 0
            ;;
    esac
    shift
done

backup_nvim
