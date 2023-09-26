
dl_transform() {
    source="$1"
    (
        println "<dl>"
        grep '^% ' "$source" |
            sed "s|^% \([^:]*\): \(.*\)$|<dt>\1</dt><dd>\2</dd>|"
        println "</dl>"
        println "</header>"
    ) > "$source.tmp"
    sed -e "$(printf '1,/<h1>/{/<h1>/i\\\n<header>\n')" -e '}' |
        sed -e "1,/<\/h1>/{/<\/h1>/r $source.tmp" -e '}'
    rm -f "$source.tmp"
}
