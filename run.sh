#!/bin/bash

PROJ_ROOT=$(dirname -- "$(readlink -f "${BASH_SOURCE}")")

function setup {
    set -x
    pip3 install yamllint ansible ansible-lint --no-input
    ansible-galaxy install -r $PROJ_ROOT/infrastructure-layer/ansible/requirements.yml
    ansible-galaxy install -r $PROJ_ROOT/platform-layer/ansible/requirements.yml
    ansible-galaxy install -r $PROJ_ROOT/software-layer/ansible/requirements.yml
}

function lint {
    set -x
    yamllint $PROJ_ROOT
    cd $PROJ_ROOT/infrastructure-layer/ansible && ansible-lint -v --offline
    cd $PROJ_ROOT/platform-layer/ansible && ansible-lint -v --offline
    cd $PROJ_ROOT/software-layer/ansible && ansible-lint -v --offline
}

function help {
    echo "$0 [-e] TASK [ARGS]"
    echo "Tasks:"
    compgen -A function | cat -n
}

# If -e is set as the first argument, exit the script 
# when a failure occurs (necessary for CI/CD)
if [ "$1" = "-e" ]; then
    set -e
    shift 1
fi

TIMEFORMAT="Task completed in %3lR"
time ${@:-help}