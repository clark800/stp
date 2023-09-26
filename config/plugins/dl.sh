
dl_transform() {
    source_path="$1"
    (
        println "<dl>"
        grep '^% ' "$source_path" |
            sed "s|^% \([^:]*\): \(.*\)$|<dt>\1</dt><dd>\2</dd>|"
        println "</dl>"
        println "</header>"
    ) > "$source_path.tmp"
    sed -e "$(printf '1,/<h1>/{/<h1>/i\\\n<header>\n')" -e '}' |
        sed -e "1,/<\/h1>/{/<\/h1>/r $source_path.tmp" -e '}'
    rm -f "$source_path.tmp"
}
