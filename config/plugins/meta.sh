
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

