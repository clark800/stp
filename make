#!/bin/sh

echo "#!/bin/sh" |
cat - plugins/*.sh config/hooks/*.sh stp |
sed '2,$s|^#!/bin/sh||' > stp.bundle
chmod +x stp.bundle
