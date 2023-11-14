readonly TITLEMAP="$TMP/titlemap"

titlemap() {
    _titlemap() {
        slug="$(slugify "$TITLE")"
        slug_path="$TITLEMAP/$slug"
        if [ -e "$slug_path" ]; then
            println "WARNING: duplicate title slug $slug" >&2
        fi
        println "$DEST_PATH" > "$slug_path"
    }
    rm -rf "$TMP/titlemap"
    mkdir -p "$TITLEMAP"
    process _titlemap "."
}
