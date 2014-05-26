#!/bin/bash -e

usage="boxer <COMMAND>

Used to build, package, and add vagrant boxes.

commands:
    box <NAME> : builds the box, packages it, adds it, and cleans up
    provision : provisions the box (basically just vagrant up)
    package <NAME> : packages and adds the currently running box
    clean : destroys the currently running box and deletes .vagrant"

provision(){
    echo "provisioning..."

    if [ ! -f "Vagrantfile" ]; then
        echo "No Vagrantfile found in the current directory!"
        return 1
    fi

    # If the machine is already running just provision.
    if vagrant status --machine-readable | grep -q '^[0-9]*,,state,running$'
    then
        vagrant provision
    else
        vagrant up --no-destroy-on-error --provision
    fi
    return 0
}

package(){
    echo "packaging..."
    
    local tmp_box=`mktemp --tmpdir tmp.XXXXXXXXX.box`
    local name="$1"
    shift

    # Forwards options to vagrant package.
    vagrant package --output $tmp_box "$@"
    vagrant box add -f --name "$name" "$tmp_box"

    rm -f $tmp_box
    return 0
}

clean(){
    echo "cleaning up..."
    vagrant destroy -f
    rm -rf .vagrant
    return 0
}

box(){
    provision && \
    package $1 && \
    clean
}

if [ $# -eq 0 ]; then
    echo "$usage"
    exit 0
fi

cmd=$1
shift
case "$cmd" in
    'box' )
        box "$1"
        ;;
    'provision' )
        provision
        ;;
    'package' )
        package "$@"
        ;;
    'clean' )
        clean
        ;;
    * )
        echo -e "\e[1;31mUNKNOWN COMMAND '$cmd'\e[0m"
        echo "usage: $usage"
        exit 1
esac