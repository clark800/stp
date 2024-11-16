# clean_html deletes files generated by non-core generators (e.g. index.html
# and directory.html) which prevents these output files from appearing in the
# index/directory listings and ensures that they get updated on each run.
# files generated by core are not deleted so that we can skip generating them
# if the output is newer than the input (since these files only depend on a
# single input file).

clean_html() {

_get_html_generator() {
    sed -n 's|<meta name="generator" content="\(.*\)">|\1|p' "$1" | head -n 1
}

_clean_html() {
    find_files "." "*.html" |
    while IFS='' read -r path; do
        generator="$(_get_html_generator "$path")"
        if [ "$generator" != "stp:core" ] &&
           [ "${generator#stp:}" != "$generator" ]; then
            rm "$path"
        fi
    done
}

_clean_html

}
