
clean_html() {
    find_files "." "*.html" |
    while IFS='' read -r path; do
        if grep -q -x '<meta name="generator" content="stp:.*">' "$path"; then
            rm "$path"
        fi
    done
}
