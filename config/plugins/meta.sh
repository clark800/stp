
insert_meta_sed_cmd() {
    printf '/<title>/i\\\n<meta name="%s" content="%s">\n;' "$1" "$2"
}

meta_transform() {
    source="$1"
    command=""
    while read -r line; do
        trimmed="${line#% }"
        if [ "$trimmed" != "$line" ]; then
            key="${trimmed%%:*}"
            value="${trimmed#*: }"
            command+="$(insert_meta_sed_cmd "$key" "$value")"
        fi
    done < "$source"
    sed "${command%;}"
}
