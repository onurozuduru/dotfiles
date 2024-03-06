#!/bin/bash
###############################################################################
#File: %FFILE%
#
#License: %LICENSE%
#
#Copyright (C) %YEAR% %USER%
#
#Follow Me!
#  github: github.com/onurozuduru
###############################################################################


### Fields
##TODO I am a template! Modify the below line!
X=""

### Functions

print_help() {
##TODO I am a template! Modify the below line!
    echo "Usage: $0 [ -x ARG1 ] [-hb]"
##TODO I am a template! Modify the below line!
# Definition of the script.
    echo -e "Some definition"
##TODO I am a template! Modify the below lines!
    echo -e "\t-h,--help\tDisplay help."
    echo -e "\t-x,--xx\t\tDo something with ARG1." #double dash arg
    echo -e "\t-b\t\tDo something."               #single dash arg
}

##TODO I am a template! Modify the below lines!
main() {
    echo "Do something!"
}

##TODO I am a template! Modify the below lines!
validate_args() {
    [[ -z "$X" ]] && echo "X is mandatory" && exit 0
    echo "X is provided!"
}

### Get params
# -l long options (--help)
# -o short options (-h)
# : options takes argument (--option1 arg1)
# $@ pass all command line parameters.
##TODO I am a template! Modify the below line!
set -e
params=$(getopt -l "help,xx:" -o "hx:b" -- "$@")

eval set -- "$params"

### Run
while true
do
    case $1 in
        -h|--help)
            print_help
            exit 0
            ;;
        -x|--xx)
            shift
            echo "Arg for X: $1"
            X="$1"
            ;;
        -b)
            echo "-b is given"
            ;;
        --)
            shift
            break;;
        *)
            print_help
            exit 0
            ;;
    esac
    shift
done

validate_args
main

