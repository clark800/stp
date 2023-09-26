
get_subdirs() {
    find "$1" ! -name "${1##*/}" -prune ! -name '.*' -type d
}

gen_directory_tree() {
    title="$(get_html_title "$1/index.html")"
    subdirs="$(get_subdirs "$1")"
    if [ "$subdirs" ]; then
        if [ "$1" == "$dir" ]; then
            println "<details open>"
        else
            println "<details>"
        fi
        println "<summary>"
        println "<a href=\"$1\">$title</a>"
        println "</summary>"
        println "$subdirs" | sort |
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
    get_header "$dir" "$title"
    println "<nav>"
    println "<h1>Directory</h1>"
    gen_directory_tree "$dir"
    println "</nav>"
    get_footer "$dir" "$title"
}

gen_directory_pages() {
    if is_writable "directory.html"; then
        log "directory.html"
        gen_directory_page "." > "directory.html"
    fi
}

register_hook gen_directory_pages
