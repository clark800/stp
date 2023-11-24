#!/bin/sh

BIN="stp"

build() {
    echo "#!/bin/sh" |
    cat - plugins/*.sh stp.sh |
    sed '2,$s|^#!/bin/sh||' > "$BIN"
    chmod +x "$BIN"
}

install() {
    PREFIX="${PREFIX:-/usr/local}"
    mkdir -p "$PREFIX/bin"
    cp "$BIN" "$PREFIX/bin/"
}

case "$1" in
    "") build;;
    install) install;;
    *) exit 1;;
esac
