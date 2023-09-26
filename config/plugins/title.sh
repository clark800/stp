
get_h1_title() {
    sed '/<\/h1>/q' | tr -d '\r\n' | sed -n 's|.*<h1>\(.*\)</h1>.*|\1|p'
}

set_title() {
    stream="$(cat)"
    title="$(println "$stream" | get_h1_title)"
    println "$stream" | sed "s|<title></title>|<title>$title</title>|"
}
