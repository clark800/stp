DATEKEY="${SSG_DATEKEY:-published}"

is_generated_index() {
    grep -q -x '<meta name="generator" content="ssg:index">' "$1"
}

set_generator() {
    sed 's/<meta name="generator" content=".*">/'\
'<meta name="generator" content="ssg:index">/'
}

find_subdirs() {
    find "$1" -name '.?*' -prune -o -type d -print
}

get_index_title() {
    if [ "${1%/}" == "." ]; then
        get_site_title
    else
        format_title "${1##*/}"
    fi
}

get_posts() {
    dir="$1"
    (cd "$dir"; find_files "." "*.html") |
    while IFS='' read -r relpath; do
        path="${dir%/}/${relpath#./}"
        date="$(cat "$path" | get_meta_value "$DATEKEY")"
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
    get_header "$dir" "$title" | set_generator
    println "<nav>"
    println "<h1>$title</h1>"
    gen_listing "$dir"
    println "</nav>"
    get_footer "$dir" "$title"
}


index_generator() {
    find_subdirs "." |
    while IFS='' read -r dir; do
        html="$dir/index.html"
        if [ ! -e "$html" ] || is_generated_index "$html"; then
            if [ "$(get_posts "$dir")" ]; then
                println "${html#./}" >&2
                gen_index_page "$dir" > "$html"
            fi
        fi
    done
}
