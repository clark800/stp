
get_title_md() {
    nx="$(printf '\nx')"
    n="${nx%x}"
    sed "/[^[:space:]]/{s/^#*[[:space:]]*//${n}q${n}}" "$SOURCE_PATH"
}
