# erase <dl> item lines when the name starts with a period.
# this lets us generate <meta> tags from <dl> syntax while making it optional
# whether the metadata should be rendered in the html.

erase_dl() {
    grep -v '^= \..*:'
}
