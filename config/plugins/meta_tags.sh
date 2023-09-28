
meta_tags() {
    if [ -e "$SOURCE_PATH" ]; then
        grep '^% ' "$SOURCE_PATH" |
            sed "s|^% \([^:]*\): \(.*\)$|<meta name=\"\1\" content=\"\2\">|"
    fi
}
