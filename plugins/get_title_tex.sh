
get_title_tex() {
    title="$(sed -n 's|^\\title{\([^}]*\)}|\1|p' "$SOURCE_PATH")"
    if [ "$title" ]; then
        println "$title"
    else
        false  # use fallback
    fi
}
