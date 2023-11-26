
get_title_md() {
    nx="$(printf '\nx')"
    n="${nx%x}"
    sed -n "/[^[:space:]]/{s/^#*[[:space:]]*//p${n}q${n}}" "$SOURCE_PATH"
}
