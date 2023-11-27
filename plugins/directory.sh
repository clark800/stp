
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

_print_link() {
    if [ -e "$1" ]; then
        println "<a href=\"$1/index.html\">$2</a>"
    else
        println "$2"
    fi
}

_generate_directory_tree() {
    root="$1"
    dir="$2"
    title="$(_get_directory_title "$dir")"
    subpages="$(_get_subpages "$dir")"
    if [ "$subpages" != "" ]; then
        if [ "$dir" = "$root" ]; then
            println "<details open>"
        else
            println "<details>"
        fi
        println "<summary>"
        _print_link "$dir" "$title"
        println "</summary>"
        println "$subpages" | sort |
        while IFS='' read -r path; do
            _generate_directory_tree "$root" "$path"
        done
        println "</details>"
    else
        _print_link "$dir" "$title"
    fi
}

_generate_directory() {
    _generate_directory_tree "." "." |
        DEST_PATH="./directory.html" generate directory.html "Directory"
}

GENERATOR="directory" _generate_directory
unset GENERATOR

}
