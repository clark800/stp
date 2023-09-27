DATEKEY="${SSG_DATEKEY:-published}"

is_generated_index() {
    grep -q -x '<meta name="generator" content="ssg:index">' "$1"
}

index() {

_get_html_title() {
    cat "$1" | tr -d '\r\n' | sed -n 's|.*<title>\(.*\)</title>.*|\1|p'
}

_get_meta_tag_content() {
    sed -n "s/<meta name=\"$1\" content=\"\(.*\)\">/\1/p"
}

_set_generator() {
    sed 's/<meta name="generator" content=".*">/'\
'<meta name="generator" content="ssg:index">/'
}

_find_subdirs() {
    find "$1" -name '.?*' -prune -o -type d -print
}

_get_posts() {
    dir="$1"
    (cd "$dir"; find_files "." "*.html") |
    while IFS='' read -r relpath; do
        path="${dir%/}/${relpath#./}"
        date="$(cat "$path" | _get_meta_tag_content "$DATEKEY")"
        if [ "$date" ]; then
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

_generate_index_page() {
    dir="$1"
    title="$(get_basename_title "$dir")"
    get_header "$dest_path" | _set_generator
    println "<nav>"
    println "<h1>$title</h1>"
    _generate_listing "$dir"
    println "</nav>"
    get_footer "$dest_path"
}


_generate_index() {
    _find_subdirs "." |
    while IFS='' read -r dir; do
        dest_path="$dir/index.html"
        if [ ! -e "$dest_path" ] || is_generated_index "$dest_path"; then
            if [ "$(_get_posts "$dir")" ]; then
                println "${dest_path#./}" >&2
                _generate_index_page "$dir" > "$dest_path"
            fi
        fi
    done
}

_generate_index

}
