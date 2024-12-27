# substitute substitutes the output of a function for lines of the form:
# $(func args)

substitute() {
    _warn() {
        println "WARNING: $1" >&2
    }

    _is_builtin() {
        /bin/sh -c "[ \"\$(command -v \"$1\")\" = \"$1\" ]"
    }

    while IFS='' read -r line; do
        start="${line#\$(}"
        cmdline="${start%)}"
        if [ "$start" != "$line" ] && [ "$cmdline" != "$start" ]; then
            cmd="${cmdline%% *}"
            if is_function "$cmd" && ! _is_builtin "$cmd"; then
                $cmdline
            else
                _warn "not a function; skipping substitution: $cmdline"
                println "$line"
            fi
        else
            println "$line"
        fi
    done
}
