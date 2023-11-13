
get_title_md() {
    grep -v '^[[:space:]]*$' "$SOURCE_PATH" | head -n 1 |
        sed 's/^#*[[:space:]]*//'
}
