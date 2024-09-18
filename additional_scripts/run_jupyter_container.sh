#!/bin/bash
###############################################################################
#File: run_jupyter_container.sh
#
#License: MIT
#
#Copyright (C) 2024 Onur Ozuduru
#
#Follow Me!
#  github: github.com/onurozuduru
###############################################################################

### Fields
PWD=$(pwd)

declare -A CONTAINER_IMAGES=(["pytorch"]="quay.io/jupyter/pytorch-notebook:cuda12-latest" ["tensorflow"]="quay.io/jupyter/tensorflow-notebook:cuda-latest")

HOST_WORK_DIR=""
CONTAINER_WORK_DIR="/home/jovyan/work"
CONTAINER_IMAGE=""
CONTAINER_PORT="8888"
HOST_PORT="8888"

### Functions

print_help() {
	echo "Usage: $0 [ -w | --workdir <WORKDIR> ] [ -i | --image <$(echo ${!CONTAINER_IMAGES[*]} | sed 's/ /|/g')> ] [-h]"
	echo -e "Run one time container jupyter notebook with podman using GPU."
	echo -e "\t-w,--workdir\tWork directory to bind, default is current directory: $PWD."
	echo -e "\t-i,--image\tImage to use. It will be asked if not specified."
	echo -e "\t-h,--help\tDisplay help."
}

get_image() {
	local prompt=""
	for image_name in "${!CONTAINER_IMAGES[@]}"; do
		prompt="$prompt\n${image_name} ${CONTAINER_IMAGES[${image_name}]}"
	done
	prompt="$(echo -e "$prompt" | column -t -o':\t' -N Name,Image)"
	prompt="$prompt\nEnter 'q' to quit!\n"
	while [[ -z "$CONTAINER_IMAGE" ]]; do
		echo -e "$prompt"
		read -rp "Enter image name: " user_input
		echo
		if [[ "$user_input" == "q" ]]; then
			echo "QUIT"
			exit 0
		fi
		CONTAINER_IMAGE="${CONTAINER_IMAGES[$user_input]}"
	done
	echo "Selected container: $user_input -> ${CONTAINER_IMAGE}"
}

set_container_image_by_arg() {
	local arg="$1"
	CONTAINER_IMAGE="${CONTAINER_IMAGES[$arg]}"
	if [[ -z "${CONTAINER_IMAGE}" ]]; then
		echo "Image name does not exist: $arg"
		exit 1
	fi
}

### Get params
# -l long options (--help)
# -o short options (-h)
# : options takes argument (--option1 arg1)
# $@ pass all command line parameters.
set -e
params=$(getopt -l "help,workdir:,image:" -o "hw:i:" -- "$@")

eval set -- "$params"

### Run
while true; do
	case $1 in
	-h | --help)
		print_help
		exit 0
		;;
	-w | --workdir)
		shift
		HOST_WORK_DIR="$1"
		;;
	-i | --image)
		shift
		set_container_image_by_arg "$1"
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

if [[ -z "${HOST_WORK_DIR}" ]]; then
	HOST_WORK_DIR="$PWD"
fi

if [[ -z "${CONTAINER_IMAGE}" ]]; then
	get_image
fi

echo "WORKDIR: $HOST_WORK_DIR"
echo "IMAGE: $CONTAINER_IMAGE"

RUN_CMD=(podman run -it --rm -p "$HOST_PORT:$CONTAINER_PORT" -v "$HOST_WORK_DIR:$CONTAINER_WORK_DIR" --userns=keep-id --device "nvidia.com/gpu=all" "$CONTAINER_IMAGE")
echo "${RUN_CMD[@]}"
"${RUN_CMD[@]}"
