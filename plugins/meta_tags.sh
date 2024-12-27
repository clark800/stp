
meta_tags() {
    if [ -e "$SOURCE_PATH" ]; then
        A='/[^[:space:]]/,/^[[:space:]]*$/'
        # erases leading period, which is used to hide the line in the html
        S='s|^= \.\{0,1\}\([^:]*\): \(.*\)$|<meta name="\1" content="\2">|p'
        Q='/^[[:space:]]*$/q'
        sed -n "$A{$S;$Q;}" "$SOURCE_PATH"
    else
        # files generated without a source file shouldn't be indexed
        echo '<meta name="index" content="no">'
    fi
}
