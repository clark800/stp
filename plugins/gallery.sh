
gallery() {
    relpath="$1"
    abspath="${SOURCE_PATH%/*}/$relpath"
    name="$(basename "$relpath")"
    count="1"
    checked="checked "

    println '<section class="gallery">'
    for filepath in "$abspath"/*; do
        filename="${filepath##*/}"
        println "<div>"
        println "<input type=\"radio\" id=\"$name-$count\" name="$name" $checked\>"
        println "<img src=\"$relpath/$filename\" \>"
        println "<label for=\"$name-$count\">"
        println "<img src=\"$relpath/$filename\" \>"
        println "</label>"
        println "</div>"
        checked=""
        count="$((count + 1))"
    done
    println "</section>"
}
