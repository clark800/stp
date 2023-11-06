BREADCRUMB_HOME_TITLE="${STP_BREADCRUMB_HOME_TITLE:-}"

breadcrumb() {

_get_html_generator() {
    sed -n 's|<meta name="generator" content="\(.*\)">|\1|p' "$1" | head -n 1
}

_is_generator_file() {
    html_generator="$(_get_html_generator "$1")"
    generator="${html_generator#stp:}"
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
    dir="${DEST_PATH%/*}/"
    tail="${dir#./}"
    dots=""
    while [ "$tail" != "" ]; do
        dots="../$dots"
        tail="${tail#*/}"
    done
    home_title="${BREADCRUMB_HOME_TITLE:-"$(get_directory_title '.')"}"
    println "<a href=\"${dots}index.html\">$home_title</a>"
    dots="${dots#*/}"
    while [ "$dots" != "" ]; do
        path="$(cd "$dir/$dots"; pwd)"
        label="$(_get_breadcrumb_title "$path")"
        println "<a href=\"${dots}index.html\">$label</a>"
        dots="${dots#*/}"
    done
}

_generate_breadcrumb

}
