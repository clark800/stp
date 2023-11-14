
wikilinks() {
    bs="$(printf '\b')"
    nx="$(printf '\nx')"
    n="${nx%x}"

    _find_wikilinks() {
        p='\[\[\([^[]*\)\]\]'
        sed -e "/^${p}/{s/${p}/\\1\\${n}/${n}P${n}D${n}}" -e "s/${p}/\\${n}&/;D"
    }

    _substitute() {
        link="$1"; href="$2"
        # there are edge cases when the link or href contain special characters
        # but these escapes should handle most common cases
        link="$(println "$link" | sed 's/[.*[]/\\&/g')"
        title="$(println "${link#*|}" | sed 's/[&]/\\&/g')"
        href="$(println "$href" | sed 's/[&]/\\&/g')"
        sed "s${bs}\\[\\[${link}\\]\\]${bs}[${title}](${href})${bs}g"
    }

    _substitute_all() {
        links="$1"
        if [ ! "$links" ]; then cat; return; fi
        link="${links%%$n*}"
        links="${links#*$n}"
        slug_path="$CONFIG/titlemap/$(slugify "${link%%|*}")"
        if [ ! -f "$slug_path" ]; then _substitute_all "$links"; return; fi
        href="$(relpath "$(cat "$slug_path")")"
        _substitute "$link" "$href" | _substitute_all "$links"
    }

    document="$(cat)"
    links="$(println "$document" | _find_wikilinks)"
    println "$document" | _substitute_all "$links$n"
}
