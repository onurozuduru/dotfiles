#!/bin/bash
###############################################################################
#File: extract_pytorch_notebooks.sh
#
#License: MIT
#
#Copyright (C) 2024 Onur Ozuduru
#
#Follow Me!
#  github: github.com/onurozuduru
###############################################################################

### Fields
declare -a REQUIRED_COMMANDS=("rg" "basename" "realpath")
BASE_DIR=""
OUTPUT_DIR=""
NOTEBOOK_PATHS=""

## Resolve full path of the given path and store in $BASE_DIR
## $1: path
fetch_real_path_to_base_dir() {
	if [[ ! -d "$1" ]]; then
		echo "Not found OR not a directory: $1"
		exit 1
	fi
	BASE_DIR=$(realpath "$1")
}

## Check if required commands are installed.
validate_requirements() {
	echo "---"
	echo "Checking if required commands are installed..."
	local not_installed_list=""
	for required_command in "${REQUIRED_COMMANDS[@]}"; do
		echo "Checking for '$required_command'"
		local command_exec
		command_exec=$(command -v "$required_command")
		if ! [ -x "$command_exec" ]; then
			not_installed_list="$not_installed_list $required_command"
		fi
	done
	if [[ -n "$not_installed_list" ]]; then
		echo "ERR: Required commands are not found: $not_installed_list"
		exit 1
	fi
	echo "OK: All installed!"
	echo "---"
}

fetch_notebook_paths() {
	echo "---"
	echo "Fetching notebooks..."
	local notebook_paths
	notebook_paths=$(rg -INo "href=.*\.ipynb\"" "$BASE_DIR" | sed 's/\(.*href="\)\(.*_downloads\/.*\.ipynb\)\(.*\)/\2/g')
	for notebook_path in $notebook_paths; do
		NOTEBOOK_PATHS="$NOTEBOOK_PATHS $BASE_DIR/$notebook_path"
	done

	if [[ -z "$NOTEBOOK_PATHS" ]]; then
		echo "ERR: No notebook found!"
		exit 1
	fi
	echo "---"
}

## Create a new directory with the base name of the BASE_DIR and copy found notebooks to there.
## If the output directory does not exist then create silently.
copy_notebooks() {
	echo "---"
	local target_dir
	target_dir="$OUTPUT_DIR/$(basename "$BASE_DIR")/"
	mkdir -p "$target_dir"
	echo "TARGET_DIR=$target_dir"
	for notebook_path in $NOTEBOOK_PATHS; do
		echo "Moving: $notebook_path"
		cp "$notebook_path" "$target_dir"
	done
	echo "---"
}

### Functions

print_help() {
	echo "Usage: $0 -b <BASE_DIR> -o <BASE_DIR> | [-h]"
	echo -e "Get .ipynb files from html links inside the given <BASE_DIR>."
	echo -e "\t-b\t\tBase directory."
	echo -e "\t-o\t\tOutput directory."
	echo -e "\t-h,--help\tDisplay help."
}

validate_args() {
	[[ -z "$BASE_DIR" ]] && echo "-b is mandatory" && exit 0
	[[ -z "$OUTPUT_DIR" ]] && echo "-o is mandatory" && exit 0
	echo "BASE_DIR=$BASE_DIR"
	echo "OUTPUT_DIR=$OUTPUT_DIR"
}

### BEFORE DOING ANYTHING CHECK IF REQUIRED COMMANDS ARE INSTALLED!
validate_requirements

set -e
params=$(getopt -l "help" -o "hb:o:" -- "$@")

eval set -- "$params"

### Run
while true; do
	case $1 in
	-h | --help)
		print_help
		exit 0
		;;
	-b)
		shift
		fetch_real_path_to_base_dir "$1"
		;;
	-o)
		shift
		OUTPUT_DIR="$1"
		;;
	--)
		shift
		break
		;;
	*)
		print_help
		exit 0
		;;
	esac
	shift
done

validate_args
fetch_notebook_paths
copy_notebooks
