
relpath() {
    path="$1"
    cwd="$(pwd)"
    dest_dir="${DEST_PATH%/*}"
    dots=""
    while [ "$(cd "$dest_dir/$dots"; pwd)" != "$cwd" ] ; do
        dots="../$dots"
    done
    println "$dots$path"
}
