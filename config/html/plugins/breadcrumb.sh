HOME_TITLE="$SSG_HOME_TITLE"

breadcrumb() {

_get_html_title() {
    cat "$1" | tr -d '\r\n' | sed -n 's|.*<title>\(.*\)</title>.*|\1|p'
}

_get_home_title() {
    if [ "$HOME_TITLE" ]; then
        println "$HOME_TITLE"
    else
        get_basename_title "."
    fi
}

_get_breadcrumb_title() {
    dir="${1%/}"
    index="$dir/index.html"
    if [ -r "$index" ] && ! is_generated_index "$index" ; then
        _get_html_title "$index"
    else
        format_title "${dir##*/}"
    fi
}

_generate_breadcrumb() {
    dir="${source_path%/*}"
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
    println "<a href=\"$head\">$(_get_home_title)</a>"
    while [ "$tail" ]; do
        head="$head${tail%%/*}/"
        tail="${tail#*/}"
        label="$(_get_breadcrumb_title ".$head")"
        println "<a href=\"$head\">$label</a>"
    done
    println "</nav>"
    println "</header>"
}

_generate_breadcrumb

}
