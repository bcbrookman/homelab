#!/bin/bash

PROJ_ROOT=$(dirname -- "$(readlink -f "${BASH_SOURCE}")")

function setup {
    set -x
    pip3 install yamllint ansible ansible-lint --no-input

    { set +x; } 2>/dev/null
    if [ -f "$PROJ_ROOT/infrastructure-layer/ansible/requirements.yml" ]; then
        set -x
        ansible-galaxy install -r $PROJ_ROOT/infrastructure-layer/ansible/requirements.yml
    fi

    { set +x; } 2>/dev/null
    if [ -f "$PROJ_ROOT/platform-layer/ansible/requirements.yml" ]; then
        set -x
        ansible-galaxy install -r $PROJ_ROOT/platform-layer/ansible/requirements.yml
    fi

    { set +x; } 2>/dev/null
    if [ -f "$PROJ_ROOT/software-layer/ansible/requirements.yml" ]; then
        set -x
        ansible-galaxy install -r $PROJ_ROOT/software-layer/ansible/requirements.yml
    fi
}

function lint {
    set -x
    cd $PROJ_ROOT && yamllint .
    export ANSIBLE_ROLES_PATH=

    { set +x; } 2>/dev/null
    if [ -d "$PROJ_ROOT/infrastructure-layer/ansible/" ]; then
        set -x
        cd $PROJ_ROOT/infrastructure-layer/ansible && ansible-lint -v
    fi
    { set +x; } 2>/dev/null
    if [ -d "$PROJ_ROOT/infrastructure-layer/ansible/" ]; then
        set -x
        cd $PROJ_ROOT/platform-layer/ansible && ansible-lint -v
    fi
    { set +x; } 2>/dev/null
    if [ -d "$PROJ_ROOT/infrastructure-layer/ansible/" ]; then
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
