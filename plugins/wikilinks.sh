
wikilinks() {
    bs="$(printf '\b')"
    nx="$(printf '\nx')"
    n="${nx%x}"

    _find_wikilinks() {
        p='\[\[\([^[]*\)\]\]'
        sed -e "/^${p}/{s/${p}/\\1\\${n}/${n}P${n}D${n}}" -e "s/${p}/\\${n}&/;D"
    }

    _substitute() {
        link="$1"; path="$2"
        # there are edge cases when the link or href contain special characters
        # but these escapes should handle most common cases
        esclink="$(println "$link" | sed 's/[.*[]/\\&/g')"
        escaped="$(println "$link" | sed 's/[&]/\\&/g')"
        label="${escaped#*|}"
        left="${escaped%%|*}"
        title="${left%%#*}"
        fragment="${left#$title}"
        href="$(println "$path$fragment" | sed 's/[&]/\\&/g')"
        sed "s${bs}\\[\\[$esclink\\]\\]${bs}<a href=\"$href\">$label</a>${bs}g"
    }

    _substitute_all() {
        link="${1%%$n*}"
        links="${1#*$n}"
        if [ ! "$link" ]; then cat && return; fi
        left="${link%%|*}"
        title="${left%%#*}"
        if [ ! "$title" ]; then
            _substitute "$link" | _substitute_all "$links"
            return
        fi
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
