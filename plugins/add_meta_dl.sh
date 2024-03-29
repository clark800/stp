
add_meta_dl() {
    : "${SOURCE_PATH:?}"
    (
        println "<dl>"
        A='/[^[:space:]]/,/^[[:space:]]*$/'
        S='s|^= \([^:]*\): \(.*\)$|<dt>\1</dt><dd>\2</dd>|p'
        Q='/^[[:space:]]*$/q'
        sed -n "$A{$S;$Q;}" "$SOURCE_PATH"
        println "</dl>"
        println "</header>"
    ) > "$SOURCE_PATH.tmp"
    sed -e "$(printf '1,/<h1>/{/<h1>/i\\\n<header>\n')" -e '}' |
        sed -e "1,/<\/h1>/{/<\/h1>/r $SOURCE_PATH.tmp" -e '}'
    rm -f "$SOURCE_PATH.tmp"
}
