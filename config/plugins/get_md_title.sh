
get_md_title() {
    cat "$source_path" | grep -v '^[[:space:]]*$' | head -n 1 |
        sed 's/^#*//' | sed 's/^[[:space:]]*//'
}
