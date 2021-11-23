#!/bin/bash
# Include trycatch.sh as a library
source ./trycatch.sh

# Define custom exception types
export ERR_BAD=100
export ERR_WORSE=101
export ERR_CRITICAL=102

function run-command {
	echo run1 ok
}
function run-command2 {
	echo run2 ok
}
function run-command3 {
	echo run3 ok # not ok
	#false
}


try
(
    echo "Start of the try block"

    # When a command returns a non-zero, a custom exception is raised.
    run-command || throw $ERR_BAD
    run-command2 || throw $ERR_WORSE
    run-command3 || throw $ERR_CRITICAL

    # This statement is not reached if there is any exception raised
    # inside the try block.
    echo "End of the try block"
)
catch || {
    case $exception_code in
        $ERR_BAD)
            echo "This error is bad"
        ;;
        $ERR_WORSE)
            echo "This error is worse"
        ;;
        $ERR_CRITICAL)
            echo "This error is critical"
        ;;
        *)
            echo "Unknown error: $exit_code"
            throw $exit_code    # re-throw an unhandled exception
        ;;
    esac
}

