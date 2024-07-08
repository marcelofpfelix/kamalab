################################################################################
#                                 FILE INFO
# lib with utility functions
################################################################################

# If CLI is set, parse ARGs and CMDS
if [[ -n "$CLI" ]]; then
    # parse the cli arguments
    result=$(echo "$CLI" | boa "$@")
    readarray -t ARGS <<<"$result"
    # check if the help flag (last arguent) is present
    if [[ ${ARGS[-1]} != "false" ]]; then
        # print the help message
        echo "$result"
        exit 1
    fi
    # replace spaces with _
    CMD="${ARGS[0]// /_}"
fi

function check_deps {
    # check that commands are available

    returnval=0
    for command in $DEPENDENCIES; do
        if ! which $command >/dev/null; then
            echo ERRO "command" "$command" "is not available"
            returnval=1
        fi
    done


    return $returnval
}
