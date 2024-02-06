_deno() {
    local i cur prev opts cmd
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd=""
    opts=""

    for i in ${COMP_WORDS[@]}
    do
        case "${cmd},${i}" in
            ",$1")
                cmd="deno"
                ;;
            deno,bench)
                cmd="deno__bench"
                ;;
            deno,bundle)
                cmd="deno__bundle"
                ;;
            deno,cache)
                cmd="deno__cache"
                ;;
            deno,check)
                cmd="deno__check"
                ;;
            deno,compile)
                cmd="deno__compile"
                ;;
            deno,completions)
                cmd="deno__completions"
                ;;
            deno,coverage)
                cmd="deno__coverage"
                ;;
            deno,do-not-use-publish)
                cmd="deno__do__not__use__publish"
                ;;
            deno,doc)
                cmd="deno__doc"
                ;;
            deno,eval)
                cmd="deno__eval"
                ;;
            deno,fmt)
                cmd="deno__fmt"
                ;;
            deno,help)
                cmd="deno__help"
                ;;
            deno,info)
                cmd="deno__info"
                ;;
            deno,init)
                cmd="deno__init"
                ;;
            deno,install)
                cmd="deno__install"
                ;;
            deno,jupyter)
                cmd="deno__jupyter"
                ;;
            deno,lint)
                cmd="deno__lint"
                ;;
            deno,lsp)
                cmd="deno__lsp"
                ;;
            deno,repl)
                cmd="deno__repl"
                ;;
            deno,run)
                cmd="deno__run"
                ;;
            deno,task)
                cmd="deno__task"
                ;;
            deno,test)
                cmd="deno__test"
                ;;
            deno,types)
                cmd="deno__types"
                ;;
            deno,uninstall)
                cmd="deno__uninstall"
                ;;
            deno,upgrade)
                cmd="deno__upgrade"
                ;;
            deno,vendor)
                cmd="deno__vendor"
                ;;
            *)
                ;;
        esac
    done

    case "${cmd}" in
        deno)
            opts="-L -q -h -V --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --help --version run bench bundle cache check compile completions coverage doc eval fmt init info install jupyter uninstall lsp lint do-not-use-publish repl task test types upgrade vendor help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__bench)
            opts="-L -q -c -r -A -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --no-check --import-map --no-remote --no-npm --node-modules-dir --vendor --config --no-config --reload --lock --lock-write --no-lock --cert --allow-read --deny-read --allow-write --deny-write --allow-net --deny-net --unsafely-ignore-certificate-errors --allow-env --deny-env --allow-sys --deny-sys --allow-run --deny-run --allow-ffi --deny-ffi --allow-hrtime --deny-hrtime --allow-all --prompt --no-prompt --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --strace-ops --check --json --ignore --filter --no-run --watch --no-clear-screen --env --help [files]... [SCRIPT_ARG]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --node-modules-dir)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --vendor)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unsafely-ignore-certificate-errors)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --strace-ops)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ignore)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --filter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__bundle)
            opts="-L -q -c -r -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --no-check --import-map --no-remote --no-npm --node-modules-dir --vendor --config --no-config --reload --lock --lock-write --no-lock --cert --check --watch --no-clear-screen --ext --help <source_file> [out_file]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --node-modules-dir)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --vendor)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ext)
                    COMPREPLY=($(compgen -W "ts tsx js jsx" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__cache)
            opts="-L -q -c -r -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --no-check --import-map --no-remote --no-npm --node-modules-dir --vendor --config --no-config --reload --lock --lock-write --no-lock --cert --check --help <file>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --node-modules-dir)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --vendor)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__check)
            opts="-L -q -c -r -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --import-map --no-remote --no-npm --node-modules-dir --vendor --config --no-config --reload --lock --lock-write --no-lock --cert --all --remote --help <file>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --node-modules-dir)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --vendor)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__compile)
            opts="-L -q -c -r -A -o -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --no-check --import-map --no-remote --no-npm --node-modules-dir --vendor --config --no-config --reload --lock --lock-write --no-lock --cert --allow-read --deny-read --allow-write --deny-write --allow-net --deny-net --unsafely-ignore-certificate-errors --allow-env --deny-env --allow-sys --deny-sys --allow-run --deny-run --allow-ffi --deny-ffi --allow-hrtime --deny-hrtime --allow-all --prompt --no-prompt --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --strace-ops --check --include --output --target --no-terminal --ext --env --help [SCRIPT_ARG]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --node-modules-dir)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --vendor)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unsafely-ignore-certificate-errors)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --strace-ops)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --include)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --output)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -o)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target)
                    COMPREPLY=($(compgen -W "x86_64-unknown-linux-gnu x86_64-pc-windows-msvc x86_64-apple-darwin aarch64-apple-darwin" -- "${cur}"))
                    return 0
                    ;;
                --ext)
                    COMPREPLY=($(compgen -W "ts tsx js jsx" -- "${cur}"))
                    return 0
                    ;;
                --env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__completions)
            opts="-L -q -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --help bash fish powershell zsh fig"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__coverage)
            opts="-L -q -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --ignore --include --exclude --lcov --output --html --detailed --help [files]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --ignore)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --include)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --exclude)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --output)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__do__not__use__publish)
            opts="-L -q -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --token --help <directory>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --token)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__doc)
            opts="-L -q -r -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --import-map --reload --lock --no-lock --no-npm --no-remote --json --html --name --output --private --filter --lint --help [source_file]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --output)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --filter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__eval)
            opts="-L -q -c -r -T -p -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --no-check --import-map --no-remote --no-npm --node-modules-dir --vendor --config --no-config --reload --lock --lock-write --no-lock --cert --inspect --inspect-brk --inspect-wait --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --strace-ops --check --ts --ext --print --env --help <CODE_ARG>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --node-modules-dir)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --vendor)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-brk)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-wait)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --strace-ops)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ext)
                    COMPREPLY=($(compgen -W "ts tsx js jsx" -- "${cur}"))
                    return 0
                    ;;
                --env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__fmt)
            opts="-L -q -c -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --config --no-config --check --ext --ignore --watch --no-clear-screen --use-tabs --line-width --indent-width --single-quote --prose-wrap --no-semicolons --help [files]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ext)
                    COMPREPLY=($(compgen -W "ts tsx js jsx md json jsonc ipynb" -- "${cur}"))
                    return 0
                    ;;
                --ignore)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --use-tabs)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --line-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --indent-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --single-quote)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --prose-wrap)
                    COMPREPLY=($(compgen -W "always never preserve" -- "${cur}"))
                    return 0
                    ;;
                --no-semicolons)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__help)
            opts="[COMMAND]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__info)
            opts="-L -q -r -c -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --reload --cert --location --no-check --no-config --no-remote --no-npm --no-lock --lock --config --import-map --node-modules-dir --vendor --json --help [file]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --node-modules-dir)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --vendor)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__init)
            opts="-L -q -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --help [dir]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__install)
            opts="-L -q -c -r -A -n -f -h --env --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --no-check --import-map --no-remote --no-npm --node-modules-dir --vendor --config --no-config --reload --lock --lock-write --no-lock --cert --allow-read --deny-read --allow-write --deny-write --allow-net --deny-net --unsafely-ignore-certificate-errors --allow-env --deny-env --allow-sys --deny-sys --allow-run --deny-run --allow-ffi --deny-ffi --allow-hrtime --deny-hrtime --allow-all --prompt --no-prompt --inspect --inspect-brk --inspect-wait --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --strace-ops --check --name --root --force --help <cmd>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --node-modules-dir)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --vendor)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unsafely-ignore-certificate-errors)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-brk)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-wait)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --strace-ops)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -n)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --root)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__jupyter)
            opts="-L -q -h --install --kernel --conn --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --conn)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__lint)
            opts="-L -q -c -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --rules --rules-tags --rules-include --rules-exclude --no-config --config --ignore --json --compact --watch --no-clear-screen --help [files]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --rules-tags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --rules-include)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --rules-exclude)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ignore)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__lsp)
            opts="-L -q -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__repl)
            opts="-L -q -c -r -A -h --env --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --no-check --import-map --no-remote --no-npm --node-modules-dir --vendor --config --no-config --reload --lock --lock-write --no-lock --cert --allow-read --deny-read --allow-write --deny-write --allow-net --deny-net --unsafely-ignore-certificate-errors --allow-env --deny-env --allow-sys --deny-sys --allow-run --deny-run --allow-ffi --deny-ffi --allow-hrtime --deny-hrtime --allow-all --prompt --no-prompt --inspect --inspect-brk --inspect-wait --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --strace-ops --check --eval-file --eval --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --node-modules-dir)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --vendor)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unsafely-ignore-certificate-errors)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-brk)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-wait)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --strace-ops)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --eval-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --eval)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__run)
            opts="-c -r -A -L -q -h --no-check --import-map --no-remote --no-npm --node-modules-dir --vendor --config --no-config --reload --lock --lock-write --no-lock --cert --allow-read --deny-read --allow-write --deny-write --allow-net --deny-net --unsafely-ignore-certificate-errors --allow-env --deny-env --allow-sys --deny-sys --allow-run --deny-run --allow-ffi --deny-ffi --allow-hrtime --deny-hrtime --allow-all --prompt --no-prompt --inspect --inspect-brk --inspect-wait --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --strace-ops --check --watch --unstable-hmr --no-clear-screen --ext --env --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --help [SCRIPT_ARG]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --node-modules-dir)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --vendor)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unsafely-ignore-certificate-errors)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-brk)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-wait)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --strace-ops)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --watch)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unstable-hmr)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ext)
                    COMPREPLY=($(compgen -W "ts tsx js jsx" -- "${cur}"))
                    return 0
                    ;;
                --env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__task)
            opts="-L -q -c -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --config --cwd --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cwd)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__test)
            opts="-L -q -c -r -A -j -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --no-check --import-map --no-remote --no-npm --node-modules-dir --vendor --config --no-config --reload --lock --lock-write --no-lock --cert --allow-read --deny-read --allow-write --deny-write --allow-net --deny-net --unsafely-ignore-certificate-errors --allow-env --deny-env --allow-sys --deny-sys --allow-run --deny-run --allow-ffi --deny-ffi --allow-hrtime --deny-hrtime --allow-all --prompt --no-prompt --inspect --inspect-brk --inspect-wait --cached-only --location --v8-flags --seed --enable-testing-features-do-not-use --strace-ops --check --ignore --no-run --trace-ops --doc --fail-fast --allow-none --filter --shuffle --coverage --parallel --jobs --watch --no-clear-screen --junit-path --reporter --env --help [files]... [SCRIPT_ARG]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --no-check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --node-modules-dir)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --vendor)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-read)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-write)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-net)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unsafely-ignore-certificate-errors)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-sys)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-run)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --allow-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --deny-ffi)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-brk)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inspect-wait)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --location)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --v8-flags)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --seed)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --strace-ops)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --check)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ignore)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --fail-fast)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --filter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --shuffle)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --coverage)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --jobs)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -j)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --junit-path)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --reporter)
                    COMPREPLY=($(compgen -W "pretty dot junit tap" -- "${cur}"))
                    return 0
                    ;;
                --env)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__types)
            opts="-L -q -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__uninstall)
            opts="-L -q -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --root --help <name>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --root)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__upgrade)
            opts="-L -q -f -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --version --output --dry-run --force --canary --cert --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --version)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --output)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        deno__vendor)
            opts="-L -q -f -c -r -h --unstable --unstable-bare-node-builtins --unstable-byonm --unstable-sloppy-imports --unstable-workspaces --unstable-broadcast-channel --unstable-cron --unstable-ffi --unstable-fs --unstable-http --unstable-kv --unstable-net --unstable-unsafe-proto --unstable-webgpu --unstable-worker-options --log-level --quiet --output --force --no-config --config --import-map --lock --node-modules-dir --vendor --reload --cert --help <specifiers>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --log-level)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                -L)
                    COMPREPLY=($(compgen -W "trace debug info" -- "${cur}"))
                    return 0
                    ;;
                --output)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --import-map)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --lock)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --node-modules-dir)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --vendor)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --reload)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -r)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
    esac
}

complete -F _deno -o bashdefault -o default deno
