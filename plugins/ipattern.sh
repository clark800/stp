
ipattern() {

    _format() {
        pattern="$1"
        path="${DEST_PATH#./}"
        ifs="$IFS"
        set -f
        IFS='/'
        set -- $path
        IFS="$ifs"
        eval println "\"$pattern\""
        set +f
    }

    for pattern; do
        filename="$(_format "$pattern")"
        if [ -e "$CONFIG/templates/$filename" ]; then
            instantiate "$filename"
            return
        fi
    done

    println "Warning: ipattern: no template found for $DEST_PATH" >&2
}
