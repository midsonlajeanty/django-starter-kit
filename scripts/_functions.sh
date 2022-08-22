#!/bin/bash
function print_info {
    echo -en "\033[36;1m"
    echo "$1"
    echo -en "\033[00m"
}

function print_error {
    echo -en "\033[31;1m"
    echo "$1"
    echo -en "\033[00m"
}

function print_success {
    echo -en "\033[32;1m"
    echo "$1"
    echo -en "\033[00m"
}