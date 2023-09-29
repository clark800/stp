
set_html_title() {

_get_h1_title() {
    sed '/<\/h1>/q' | tr -d '\r\n' | sed -n 's|.*<h1>\(.*\)</h1>.*|\1|p'
}

_set_html_title() {
    stream="$(cat)"
    title="$(println "$stream" | _get_h1_title)"
    if [ "$title" != "" ]; then
        println "$stream" | sed "s|<title>.*</title>|<title>$title</title>|"
    else
        println "$stream"
    fi
}

_set_html_title

}
