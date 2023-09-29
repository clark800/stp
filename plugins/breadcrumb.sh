BREADCRUMB_HOME_TITLE="${SSG_BREADCRUMB_HOME_TITLE:-}"

breadcrumb() {

_get_html_generator() {
    sed -n 's|<meta name="generator" content="\(.*\)">|\1|p' "$1" | head -n 1
}

_is_generator_file() {
    html_generator="$(_get_html_generator "$1")"
    generator="${html_generator#ssg:}"
    [ "$generator" != "$html_generator" ] && [ "$generator" != "core" ]
}

_get_html_title() {
    tr -d '\r\n' < "$1" | sed -n 's|.*<title>\(.*\)</title>.*|\1|p'
}

_get_breadcrumb_title() {
    dir="${1%/}"
    index="$dir/index.html"
    if [ -r "$index" ] && ! _is_generator_file "$index" ; then
        _get_html_title "$index"
    else
        get_directory_title "$dir"
    fi
}

_generate_breadcrumb() {
    if [ "$DEST_PATH" = "./index.html" ]; then
        return
    fi
    tail="${DEST_PATH%/*}"
    tail="${tail%/*}/" # start with parent directory
    tail="${tail#.}"
    tail="${tail#/}"   #  a/b/    b/      ''
    head="/"           # /     /a/   /a/b/
    home_title="${BREADCRUMB_HOME_TITLE:-"$(get_directory_title '.')"}"
    println "<a href=\"$head\">$home_title</a>"
    while [ "$tail" != "" ]; do
        head="$head${tail%%/*}/"
        tail="${tail#*/}"
        label="$(_get_breadcrumb_title ".$head")"
        println "<a href=\"$head\">$label</a>"
    done
}

_generate_breadcrumb

}
