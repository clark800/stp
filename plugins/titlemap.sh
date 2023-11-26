
titlemap() {
    _titlemap() {
        slug="$(slugify "$(title)")"
        slug_path="$TMP/titlemap/$slug"
        if [ -e "$slug_path" ]; then
            println "WARNING: duplicate title slug $slug" >&2
        fi
        println "$DEST_PATH" > "$slug_path"
    }
    rm -rf "$TMP/titlemap"
    mkdir -p "$TMP/titlemap"
    process _titlemap "."
}
