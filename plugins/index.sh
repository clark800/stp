INDEX_DATE_KEY="${STP_INDEX_DATE_KEY:-published}"

index() {

_is_generated_index() {
    grep -q -x "<meta name=\"generator\" content=\"stp:$GENERATOR\">" "$1"
}

_is_no_index() {
    grep -q -x '<meta name="index" content="no">' "$1"
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
        # -s makes sure we don't index the file we are currently generating
        if [ -s "$path" ] && ! _is_no_index "$path"; then
            date="$(_get_meta_tag_content "$INDEX_DATE_KEY" < "$path")"
            # use pipe separator so posts with no date are sorted higher
            println "$date|${relpath#./}"
        fi
    done
}

_generate_listing() {
    dir="$1"
    _get_posts "$dir" | sort -r |
    while IFS='' read -r line; do
        date="${line%%|*}"
        relpath="${line#*|}"
        path="${dir%/}/$relpath"
        title="$(_get_html_title "$path")"
        println "<section>"
        if [ "$date" ]; then
            println "<time>$date</time>"
        fi
        println "<a href=\"$relpath\">$title</a>"
        println "</section>"
    done
}

_is_ok_to_write() {
    [ ! -s "$1" ] || _is_generated_index "$1"
}

_is_any_indexed() {
    while IFS='' read -r html_path; do
        if ! _is_no_index "$html_path"; then
            return 0
        fi
    done
    return 1
}

_needs_update() {
    if [ ! -s "$1" ]; then
       return 0  # true
    fi
    find "${1%/*}" -name "*.html" -newer "$1" | _is_any_indexed
}

_generate_index() {
    # index generation is done as a preorder traversal because each index needs
    # all its parents to generate the titles for the breadcrumb navigation and
    # parents do not need children because index files are not indexed - they
    # are listed in the directory which is generated after all index files
    _find_subdirs "." |
    while IFS='' read -r dir; do
        dest_path="$dir/index.html"
        if _is_ok_to_write "$dest_path" && _needs_update "$dest_path"; then
            if [ "$(_get_posts "$dir")" != "" ]; then
                title="$(get_directory_title "$dir")"
                _generate_listing "$dir" |
                    DEST_PATH="$dest_path" generate index.html "$title"
            fi
        fi
    done
}

GENERATOR="index" _generate_index
unset GENERATOR

}
