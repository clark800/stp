
get_title_shtml() {
    _extract() {
        cat "$SOURCE_PATH" | tr -d '\r\n' |
            sed -n -e "s|</\\($1\\)>.*|</\\1>|" \
                   -e "s|.*<$1>\\(.*\\)</$1>.*|\\1|p" \
                   -e 's|^[[:space:]]*||' -e 's|[[:space:]]*$||'
    }

    for tag in '[Tt][Ii][Tt][Ll][Ee]' '[Hh]1' '[Hh]2'; do
        title="$(_extract "$tag")"
        if [ "$title" ]; then
            println "$title"
            return
        fi
    done
}
