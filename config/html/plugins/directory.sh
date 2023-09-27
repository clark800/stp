
get_subdirs() {
    find "$1" ! -name "${1##*/}" -prune ! -name '.*' -type d
}

get_subpages() {
    get_subdirs "$1" |
    while IFS='' read -r subdir; do
        if [ -r "$subdir/index.html" ]; then
            println "$subdir"
        fi
    done
}

gen_directory_tree() {
    title="$(get_html_title "$1/index.html")"
    subpages="$(get_subpages "$1")"
    if [ "$subpages" ]; then
        if [ "$1" == "$dir" ]; then
            println "<details open>"
        else
            println "<details>"
        fi
        println "<summary>"
        println "<a href=\"$1\">$title</a>"
        println "</summary>"
        println "$subpages" | sort |
        while IFS='' read -r path; do
            gen_directory_tree "$path"
        done
        println "</details>"
    else
        println "<a href=\"$1\">$title</a>"
    fi
}

gen_directory_page() {
    dir="$1"
    title="Directory"
    get_header "$dest_path"
    println "<nav>"
    println "<h1>$title</h1>"
    gen_directory_tree "$dir"
    println "</nav>"
    get_footer "$dest_path"
}

directory_generator() {
    dest_path="./directory.html"
    println "${dest_path#*/}" >&2
    gen_directory_page "." > "$dest_path"
}
