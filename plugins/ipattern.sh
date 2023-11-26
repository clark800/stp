# ipattern: select a template based on the destination path and instantiate
# for example, to include a submenu based on the top-level directory name:
#   $(ipattern '${1:-root}-menu.html')

ipattern() {

    _format() {
        pattern="$1"
        path="${DEST_PATH%/*}/"
        path="${path#./}"
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
