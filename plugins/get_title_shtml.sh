
get_title_shtml() {
    _extract() {
        cat "$SOURCE_PATH" |
            sed -n "/<$1>/,\${p;/<\/$1>/q;}" | tr -d '\r\n' |
            sed -n -e "s|.*<$1>\\(.*\\)</$1>.*|\\1|" \
                   -e 's|^[[:space:]]*||' -e 's|[[:space:]]*$||' -e 'p'
    }

    for tag in '[Tt][Ii][Tt][Ll][Ee]' '[Hh]1' '[Hh]2'; do
        title="$(_extract "$tag")"
        if [ "$title" ]; then
            println "$title"
            return
        fi
    done
    false  # use fallback
}
