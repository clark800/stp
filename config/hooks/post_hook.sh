
post_hook() {
    rm -f directory.html
    run_generator html index
    run_generator html directory
}
