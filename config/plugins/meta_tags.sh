
meta_tags() {
    if [ -e "$source_path" ]; then
        grep '^% ' "$source_path" |
            sed "s|^% \([^:]*\): \(.*\)$|<meta name=\"\1\" content=\"\2\">|"
    fi
}
