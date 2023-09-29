INDEX_DATE_KEY="${SSG_INDEX_DATE_KEY:-published}"

index() {

_is_generated_index() {
    grep -q -x "<meta name=\"generator\" content=\"ssg:$GENERATOR\">" "$1"
}

_get_html_title() {
    tr -d '\r\n' < "$1" | sed -n 's|.*<title>\(.*\)</title>.*|\1|p'
}

_get_meta_tag_content() {
    sed -n "s/<meta name=\"$1\" content=\"\(.*\)\">/\1/p"
}

_find_subdirs() {
    find "$1" -name '.?*' -prune -o -type d -print
}

_get_posts() {
    dir="$1"
    (cd "$dir" && find_files "." "*.html") |
    while IFS='' read -r relpath; do
        path="${dir%/}/${relpath#./}"
        date="$(_get_meta_tag_content "$INDEX_DATE_KEY" < "$path")"
        if [ "$date" != "" ]; then
            println "$date ${relpath#./}"
        fi
    done
}

_generate_listing() {
    dir="$1"
    _get_posts "$dir" | sort -r -k 1 |
    while IFS='' read -r line; do
        date="${line%% *}"
        relpath="${line#* }"
        path="${dir%/}/$relpath"
        title="$(_get_html_title "$path")"
        println "<section>"
        println "<time>$date</time>"
        println "<a href=\"$relpath\">$title</a>"
        println "</section>"
    done
}

_generate_index_content() {
    dir="$1"
    println "<nav>"
    println "<h1>$TITLE</h1>"
    _generate_listing "$dir"
    println "</nav>"
}

_is_ok_to_write() {
    [ ! -s "$1" ] || _is_generated_index "$1"
}

_generate_index() {
    _find_subdirs "." |
    while IFS='' read -r dir; do
        DEST_PATH="$dir/index.html"
        if _is_ok_to_write "$DEST_PATH"; then
            if [ "$(_get_posts "$dir")" != "" ]; then
                println "${DEST_PATH#./}" >&2
                TITLE="$(get_directory_title "$dir")"
                _generate_index_content "$dir" | wrap > "$DEST_PATH"
            fi
        fi
    done
}

_generate_index

}