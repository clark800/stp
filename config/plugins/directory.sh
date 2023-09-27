
directory() {

_get_html_title() {
    cat "$1" | tr -d '\r\n' | sed -n 's|.*<title>\(.*\)</title>.*|\1|p'
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

_generate_directory_tree() {
    title="$(_get_html_title "$1/index.html")"
    subpages="$(_get_subpages "$1")"
    if [ "$subpages" ]; then
        if [ "$1" = "$dir" ]; then
            println "<details open>"
        else
            println "<details>"
        fi
        println "<summary>"
        println "<a href=\"$1\">$title</a>"
        println "</summary>"
        println "$subpages" | sort |
        while IFS='' read -r path; do
            _generate_directory_tree "$path"
        done
        println "</details>"
    else
        println "<a href=\"$1\">$title</a>"
    fi
}

_generate_directory_page() {
    dir="$1"
    title="Directory"
    instantiate_template html header "$dest_path"
    println "<nav>"
    println "<h1>$title</h1>"
    _generate_directory_tree "$dir"
    println "</nav>"
    instantiate_template html footer "$dest_path"
}

_generate_directory() {
    generator="directory"
    dest_path="./directory.html"
    println "${dest_path#*/}" >&2
    _generate_directory_page "." > "$dest_path"
    unset generator
}

_generate_directory

}
