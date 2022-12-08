#!/bin/bash

PROJ_ROOT=$(dirname -- "$(readlink -f "${BASH_SOURCE}")")

function setup {
    set -x
    pip3 install yamllint ansible ansible-lint --no-input
    export ANSIBLE_ROLES_PATH=${HOME}/.ansible/roles/
    export ANSIBLE_COLLECTIONS_PATH=${HOME}/.ansible/collections/
    ansible-galaxy install -r requirements.yaml
}

function lint {
    set -x
    cd $PROJ_ROOT && yamllint .
    export ANSIBLE_ROLES_PATH=${HOME}/.ansible/roles/
    export ANSIBLE_COLLECTIONS_PATH=${HOME}/.ansible/collections/

    { set +x; } 2>/dev/null
    if [ -d "$PROJ_ROOT/infrastructure-layer/ansible/" ]; then
        set -x
        cd $PROJ_ROOT/infrastructure-layer/ansible && ansible-lint -v
    fi
    { set +x; } 2>/dev/null
    if [ -d "$PROJ_ROOT/platform-layer/ansible/" ]; then
        set -x
        cd $PROJ_ROOT/platform-layer/ansible && ansible-lint -v
    fi
    { set +x; } 2>/dev/null
    if [ -d "$PROJ_ROOT/software-layer/ansible/" ]; then
        set -x
        cd $PROJ_ROOT/software-layer/ansible && ansible-lint -v
    fi
}

function help {
    echo "$0 [-e] TASK [ARGS]"
    echo "Tasks:"
    compgen -A function | grep -v ^_ | cat -n
}

# If -e is set as the first argument, exit the script
# when a failure occurs (necessary for CI/CD)
if [ "$1" = "-e" ]; then
    set -e
    shift 1
fi

TIMEFORMAT="Task completed in %3lR"
time ${@:-help}
