
get_md_title() {
    grep -v '^[[:space:]]*$' "$SOURCE_PATH" | head -n 1 |
        sed 's/^#*//' | sed 's/^[[:space:]]*//'
}
