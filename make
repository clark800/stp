#!/bin/sh

echo "#!/bin/sh" |
cat - plugins/*.sh stp.sh |
sed '2,$s|^#!/bin/sh||' > stp
chmod +x stp

if [ "$1" = "install" ]; then
    PREFIX="${PREFIX:-/usr/local}"
    mkdir -p "$PREFIX/bin"
    cp stp "$PREFIX/bin/"
fi
