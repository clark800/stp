
get_md_title() {
    cat "$SOURCE_PATH" | grep -v '^[[:space:]]*$' | head -n 1 |
        sed 's/^#*//' | sed 's/^[[:space:]]*//'
}
