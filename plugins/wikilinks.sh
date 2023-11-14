
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
        sed "s${bs}\\[\\[$link\\]\\]${bs}<a href=\"$href\">$title</a>${bs}g"
    }

    _substitute_all() {
        link="${1%%$n*}"
        links="${1#*$n}"
        if [ ! "$link" ]; then cat && return; fi
        title="${link%%|*}"
        slug_path="$TMP/titlemap/$(slugify "$title")"
        if [ ! -f "$slug_path" ]; then
            println "WARNING: page not found for wikilink '$title'" >&2
            _substitute_all "$links"
            return
        fi
        href="$(relpath "$(cat "$slug_path")")"
        _substitute "$link" "$href" | _substitute_all "$links"
    }

    if [ ! -d "$TMP/titlemap" ]; then
        println "WARNING: titlemap not found; skipping wikilinks" >&2
        cat && return
    fi

    document="$(cat)"
    links="$(println "$document" | _find_wikilinks)"
    println "$document" | _substitute_all "$links$n"
}
