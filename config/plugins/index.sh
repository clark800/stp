DATEKEY="${SSG_DATEKEY:-published}"

find_subdirs() {
    find "$1" -name '.?*' -prune -o -type d -print
}

get_posts() {
    dir="$1"
    (cd "$dir"; find_files "." "*.html") |
    while IFS='' read -r relpath; do
        path="${dir%/}/${relpath#./}"
        date="$(get_meta_value "$DATEKEY" "$path")"
        if [ "$date" ]; then
            println "$date ${relpath#./}"
        fi
    done
}

gen_listing() {
    dir="$1"
    get_posts "$dir" | sort -r -k 1 |
    while IFS='' read -r line; do
        date="${line%% *}"
        relpath="${line#* }"
        path="${dir%/}/$relpath"
        title="$(get_html_title "$path")"
        println "<section>"
        println "<time>$date</time>"
        println "<a href=\"$relpath\">$title</a>"
        println "</section>"
    done
}

gen_index_page() {
    dir="$1"
    title="$(get_index_title "$dir")"
    get_header "$dir" "$title"
    println "<nav>"
    println "<h1>$title</h1>"
    gen_listing "$dir"
    println "</nav>"
    get_footer "$dir" "$title"
}


index_hook() {
    # the second pass does a post-order traversal to generate index files so
    # that we know which directories contain pages without another recursive
    # search; we don't want to generate index files for direcories that only
    # contain images for example
    find_subdirs "." | LC_ALL=C sort -r |
    while IFS='' read -r dir; do
        html="$dir/index.html"
        if [ ! -e "$dir/index.$EXT" ] && is_writable "$html"; then
            if [ "$(get_posts "$dir")" ]; then
                log "${html#./}"
                gen_index_page "$dir" > "$html"
            fi
        fi
    done
}
