# Handling errors in bash + simulated try/catch
# https://www.xmodulo.com/catch-handle-errors-bash.html
# See try-test.sh for example usage

# Although the set command allows you to terminate a bash script upon any error that you deem critical, this mechanism is often not sufficient in more complex bash scripts where different types of errors could happen.

# To be able to detect and handle different types of errors/exceptions more flexibly, you will need try/catch statements, which however are missing in bash. At least we can mimic the behaviors of try/catch as shown in this trycatch.sh script:

function try()
{
    [[ $- = *e* ]]; SAVED_OPT_E=$?
    set +e
}

function throw()
{
    exit $1
}

function catch()
{
    export exception_code=$?
    (( $SAVED_OPT_E )) && set +e
    return $exception_code
}

