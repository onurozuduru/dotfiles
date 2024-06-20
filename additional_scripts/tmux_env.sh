#!/bin/sh
###############################################################################
#File: tmux_env.sh
#
#License: MIT
#
#Copyright (C) 2021 Onur Ozuduru
#
#Follow Me!
#  github: github.com/onurozuduru
###############################################################################
# shellcheck disable=3037

### Constants

WORKSPACE=$(pwd)
SESSION="DevEnv"
WIN_MAIN="$SESSION:0.0"
WIN_SECOND="$SESSION:0.1"
SPLIT_RATIO="-p 20" #in %
SPLIT_ORIENTATION="-v"

### Functions

print_help() {
    echo "Usage: $0 [ -w | --workspace <path> ] [ -V | -H | -N ] [ -r | --ratio <percentage> ] [ -h | --help ]"
    echo "Run tmux environment with one window that could split in vertically or horizontally as desired."
    echo -e "\t-h,--help\tDisplay help."
    echo -e "\t-w,--workspace\tLocation to go in tmux window. Default: current directory."
    echo -e "\t-V\t\tVertical split."
    echo -e "\t-H\t\tHorizontal split. *Default mode!"
    echo -e "\t-N\t\tNo split."
    echo -e "\t-r,--ratio\tSplit ratio (if -V or -H is given). Uses percentage (%) as unit. Default: 20"
    echo "Default: $0 -w $(pwd) -H -r 20"
}

start_tmux() {
    # -x and -y are to keep terminal size to not loose split percentage
    if tmux new -s $SESSION -d -x - -y -; then
        if [ -n "$WIN_SECOND" ]; then
            tmux split-window -t "$SESSION" "$SPLIT_ORIENTATION" "$SPLIT_RATIO"
            tmux send-keys -t $WIN_SECOND "cd $WORKSPACE && clear" Enter
        fi
        tmux send-keys -t $WIN_MAIN "cd $WORKSPACE" Enter
        tmux select-pane -t $WIN_MAIN
    fi
    tmux attach -t $SESSION
}

### Get params
# -l long options (--help)
# -o short options (-h)
# : options takes argument (--option1 arg1)
# $@ pass all command line parameters.
set -e
params=$(getopt -l "help,workspace:,ratio:" -o "hw:r:HVN" -- "$@")

eval set -- "$params"

### Run
while true; do
    case $1 in
    -h | --help)
        print_help
        exit 0
        ;;
    -w | --workspace)
        shift
        WORKSPACE=$1
        ;;
    -r | --ratio)
        shift
        SPLIT_RATIO=$1
        SPLIT_RATIO="-p $SPLIT_RATIO"
        ;;
    -V)
        SPLIT_ORIENTATION="-h"
        ;;
    -H)
        SPLIT_ORIENTATION="-v"
        ;;
    -N)
        SPLIT_ORIENTATION=""
        SPLIT_RATIO=""
        WIN_SECOND=""
        WIN_MAIN="$SESSION:0"
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

start_tmux
