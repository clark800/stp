
meta_tags() {
    if [ -e "$SOURCE_PATH" ]; then
        sed -n 's|^% \([^:]*\): \(.*\)$|<meta name="\1" content="\2">|p' \
            "$SOURCE_PATH"
    fi
}
