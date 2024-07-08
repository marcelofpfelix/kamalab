#!/bin/bash

################################################################################
#                                 FILE INFO
# reload in case of file changes, using node notify inotifywait
################################################################################

# if the script is interrupted, the run process should be killed
sigint_handler(){
    kill $PID 2>/dev/null
    exit
}

# sets up a signal handler to execute sigint_handler when the SIGINT signal
# (Ctrl+C) is received
trap sigint_handler SIGINT

main() {
    dir=${1:-"."}
    # remove $1 from args
    shift;

    while true; do
        # run command in background
        $@ &

        # get PID of last background process
        PID=$!
        # wait for changes
        inotifywait -qqre create,delete,modify,move "$dir"
        # -e: events to watch
        # -m: monitor events indefinitely
        # -r: recursive
        # -q: quiet nothing
        date
        echo "reloading...$PWD"
        # kill last background process
        kill $PID &> /dev/null
    done
}


main "$@"
