
pre_hook() {
    _titlemap() {
        slug="$(slugify "$TITLE")"
        slug_path="$CONFIG/titlemap/$slug"
        if [ -e "$slug_path" ]; then
            println "Warning: duplicate title slug $slug"
        fi
        println "$DEST_PATH" > "$slug_path"
    }
    rm -rf "${CONFIG?:}/titlemap"
    TITLEMAP="$CONFIG/titlemap"
    mkdir "$TITLEMAP"
    process _titlemap "."
}
