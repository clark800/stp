
get_home_title() {
    if [ "$SSG_HOME" ]; then
        println "$SSG_HOME"
    else
        get_site_title
    fi
}

get_breadcrumb_title() {
    dir="${1%/}"
    index="$dir/index.html"
    if [ -r "$index" ] && [ -r "$dir/index.$EXT" ]; then
        get_html_title "$index"
    elif [ -r "$index" ] && ! is_generated "$index" ; then
        get_html_title "$index"
    else
        get_index_title "$dir"
    fi
}

gen_breadcrumb() {
    dir="${1:-$dir}"
    tail="${dir%/}"
    if [ "$tail" == "." ]; then
        println '<header>'
        println '</header>'
        return
    fi
    tail="${tail%/*}/" # start with parent directory
    tail="${tail#.}"
    tail="${tail#/}"   #  a/b/    b/      ''
    head="/"           # /     /a/   /a/b/
    println "<header>"
    println "<nav>"
    println "<a href=\"$head\">$(get_home_title)</a>"
    while [ "$tail" ]; do
        head="$head${tail%%/*}/"
        tail="${tail#*/}"
        label="$(get_breadcrumb_title ".$head")"
        println "<a href=\"$head\">$label</a>"
    done
    println "</nav>"
    println "</header>"
}
