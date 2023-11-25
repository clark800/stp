
directory() {

_get_html_title() {
    tr -d '\r\n' < "$1" | sed -n 's|.*<title>\(.*\)</title>.*|\1|p'
}

_get_subdirs() {
    find "$1" ! -name "${1##*/}" -prune ! -name '.*' -type d
}

_get_subpages() {
    _get_subdirs "$1" |
    while IFS='' read -r subdir; do
        if [ -r "$subdir/index.html" ]; then
            println "$subdir"
        fi
    done
}

_get_directory_title() {
    if [ -r "$1/index.html" ]; then
        _get_html_title "$1/index.html"
    else
        get_directory_title "$1"
    fi
}

_generate_directory_tree() {
    title="$(_get_directory_title "$1")"
    subpages="$(_get_subpages "$1")"
    if [ "$subpages" != "" ]; then
        if [ "$1" = "$dir" ]; then
            println "<details open>"
        else
            println "<details>"
        fi
        println "<summary>"
        println "<a href=\"$1/index.html\">$title</a>"
        println "</summary>"
        println "$subpages" | sort |
        while IFS='' read -r path; do
            _generate_directory_tree "$path"
        done
        println "</details>"
    else
        println "<a href=\"$1/index.html\">$title</a>"
    fi
}

_generate_directory_page() {
    dir="$1"
    instantiate header
    println "<nav>"
    println "<h1>$TITLE</h1>"
    if [ -r "$dir/index.html" ]; then
        _generate_directory_tree "$dir"
    fi
    println "</nav>"
    instantiate footer
}

_generate_directory() {
    DEST_PATH="./directory.html"
    TITLE="Directory"
    println "${DEST_PATH#*/}" >&2
    _generate_directory_page "." > "$DEST_PATH"
}

_generate_directory

}
