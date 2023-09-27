
insert_meta_sed_cmd() {
    printf '/<title>/i\\\n<meta name="%s" content="%s">\n;' "$1" "$2"
}

insert_meta_tags() {
    source_path="$1"
    command=""
    while read -r line; do
        trimmed="${line#% }"
        if [ "$trimmed" != "$line" ]; then
            key="${trimmed%%:*}"
            value="${trimmed#*: }"
            command+="$(insert_meta_sed_cmd "$key" "$value")"
        fi
    done < "$source_path"
    sed "${command%;}"
}

insert_meta_dl() {
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
