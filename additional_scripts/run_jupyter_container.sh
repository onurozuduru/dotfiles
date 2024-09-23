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
ARGS_CONTAINER_NAME=""
ARGS_CONTAINER_REMOVE=""

COMMAND_ARGS=""

EXISTING_CONTAINER_NAMES=$(podman ps -a --format "{{.Names}}")
EXISTING_CONTAINERS=$(podman ps -a --format "{{.Names}} {{.Image}}" | column -t -o':\t' -N "Container Name,Base Image")

IS_ONLY_START=""

### Functions

print_help() {
	echo "Usage: $0 [ -w | --workdir <WORKDIR> ] [ -i | --image <$(echo ${!CONTAINER_IMAGES[*]} | sed 's/ /|/g')> ] [ --rm | --name <NAME> ] [-h]"
	echo -e "Run one time container jupyter notebook with podman using GPU."
	echo -e "\t-w,--workdir\tWork directory to bind, default is current directory: $PWD."
	echo -e "\t-i,--image\tImage to use. It will be asked if not specified."
	echo -e "\t--rm\t\tRemove the container on exit. It will be asked if not specified. CANNOT BE USED WITH --name"
	echo -e "\t--name\t\tKeep the container with the <name>. It will be asked if not specified. CANNOT BE USED WITH --rm"
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

## Check if given container exists and set IS_ONLY_START, keep name otherwise
# $1: Name
set_name() {
	local user_input="$1"
	echo "NAME: $user_input"
	for container_name in ${EXISTING_CONTAINER_NAMES}; do
		if [[ "${container_name}" == "${user_input}" ]]; then
			COMMAND_ARGS="--interactive --attach ${container_name}"
			IS_ONLY_START="YES"
			echo "Found existing container: $user_input"
			return
		fi
	done
	COMMAND_ARGS="--name ${user_input}"
}

get_args_name_or_rm() {
	local prompt="\n------------------\n"
	if [[ -n "${EXISTING_CONTAINERS}" ]]; then
		prompt="$prompt\nExisting containers:\n${EXISTING_CONTAINERS}\n"
		prompt="$prompt\nUse name from the above list, if you want to start one of the existing containers!\n"
	fi
	prompt="$prompt\nDon't give name to remove container on exit!\n"
	prompt="$prompt\nEnter 'q' to quit!\n"
	echo -e "$prompt"
	read -rp "Enter container name (leave empty to remove on exit): " user_input
	echo
	if [[ "$user_input" == "q" ]]; then
		echo "QUIT"
		exit 0
	fi
	if [[ -z "$user_input" ]]; then
		COMMAND_ARGS="--rm"
	else
		set_name "$user_input"
	fi
}

### Get params
# -l long options (--help)
# -o short options (-h)
# : options takes argument (--option1 arg1)
# $@ pass all command line parameters.
set -e
params=$(getopt -l "help,workdir:,image:,name:,rm" -o "hw:i:" -- "$@")

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
	--name)
		shift
		ARGS_CONTAINER_NAME="--name $1"
		set_name "$ARGS_CONTAINER_NAME"
		;;
	--rm)
		ARGS_CONTAINER_REMOVE="--rm"
		COMMAND_ARGS="$ARGS_CONTAINER_REMOVE"
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

if [[ -n "${ARGS_CONTAINER_NAME}" ]] && [[ -n "${ARGS_CONTAINER_REMOVE}" ]]; then
	echo "--name and --rm cannot be specified at the same time!"
	exit 1
fi

if [[ -z "${ARGS_CONTAINER_NAME}" ]] && [[ -z "${ARGS_CONTAINER_REMOVE}" ]]; then
	get_args_name_or_rm
fi

echo "WORKDIR: $HOST_WORK_DIR"
echo "IMAGE: $CONTAINER_IMAGE"

if [[ -n "${IS_ONLY_START}" ]]; then
	RUN_CMD=(podman start $COMMAND_ARGS)
else
	RUN_CMD=(podman run -it $COMMAND_ARGS -p "$HOST_PORT:$CONTAINER_PORT" -v "$HOST_WORK_DIR:$CONTAINER_WORK_DIR" --userns=keep-id --device "nvidia.com/gpu=all" "$CONTAINER_IMAGE")
fi

echo "${RUN_CMD[@]}"
"${RUN_CMD[@]}"
