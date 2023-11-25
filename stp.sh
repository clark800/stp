#!/bin/sh
set -e
readonly CONFIG="${STP_CONFIG:-.stp}"
readonly TMP="$CONFIG/tmp"
ROOT_TITLE="${STP_ROOT_TITLE:-}"
TITLE_FORMAT="${STP_TITLE_FORMAT-capitalize}"
TITLE_SPACE_CHARACTERS="${STP_TITLE_SPACE_CHARACTERS-_-}"

println() {
    for line; do printf '%s\n' "$line"; done
}

slugify() {
    println "$1" | sed 's|[^[:alnum:]_-]|_|g;s|__*|_|g;s|^_||;s|_$||'
}

is_function() {
    [ "$1" != "" ] && [ "$(command -v "$1")" = "$1" ]
}

try() {
    if is_function "${1:?}" && "$1"; then return; else shift && try "$@"; fi
}

find_files() {
    find "$1" -name '.?*' -prune -o -type f -name "$2" -print
}

capitalize() {
    tr ' ' '\n' |
    while IFS='' read -r word; do
        printf ' %.1s' "$word" | tr '[:lower:]' '[:upper:]'
        printf '%s' "${word#?}"
    done | cut -c 2-
}

format_title() {
    _format() { tr " $TITLE_SPACE_CHARACTERS" '[ *]' | ${TITLE_FORMAT:-cat}; }
    println "$1" | if [ "${1%.*}" != "$1" ]; then cat; else _format; fi
}

get_directory_title() {
    title="$(format_title "$(basename "$1")")"
    root_title="${ROOT_TITLE:-"$(format_title "$(basename "$(pwd)")")"}"
    if [ "${1%/}" = "." ]; then println "$root_title"; else println "$title"; fi
}

get_file_title() {
    _fallback() { format_title "$(basename "$DEST_PATH" ".${DEST_PATH##*.}")"; }
    try "get_title_${SOURCE_PATH##*.}" _fallback
}

input() {
    "${@:-cat}" < "${SOURCE_PATH:?}"
}

relpath() {
    dir="${DEST_PATH%/*}/"
    println "$(println "${dir#./}" | sed 's|[^/]*/|\.\./|g')${1#./}"
}

instantiate() {
    : "${GENERATOR:?}" "${TITLE:?}" "${DEST_PATH:?}"
    path="${1:+"$CONFIG/templates/$1"}"
    path="${path:-"$SOURCE_PATH"}"
    eval "printf '%s\\n' \"$(sed 's/\\*\(["`]\)/\\\1/g' "$path")\""
}

run_generator() {
    GENERATOR="${2:?}" SOURCE_PATH="" DEST_PATH="" TITLE="" "$2"
}

import() {
    if [ -d "$1" ]; then
        for plugin in "$1"/*.sh; do
            if [ -e "$plugin" ]; then . "$plugin"; fi
        done
    fi
}

process() {
    processor="$1"; root="${2%/.}";
    ls "$CONFIG/templates" | grep -F '.to.' | LC_ALL=C sort |
    while IFS='' read -r template_filename; do
        source_ext="${template_filename%%.to.*}"
        dest_ext="${template_filename#*.to.}"
        find_files "${root%/}" "*.$source_ext" |
        while IFS='' read -r SOURCE_PATH; do
            DEST_PATH="${SOURCE_PATH%.$source_ext}.$dest_ext"
            TITLE="$(get_file_title)"
            "$processor" "$source_ext" "$dest_ext"
        done
    done
}

generate() {
    println "${DEST_PATH#./}" >&2
    instantiate "$1.to.$2" > "$DEST_PATH"
}

main() {
    import "$CONFIG/plugins"
    import "$CONFIG/hooks"
    if [ "$#" = 0 ]; then try pre_hook :; fi
    for path in "${@:-.}"; do
        rel="${path#$PWD/}"
        if [ "${rel#/}" = "$rel" ] && [ "${rel#*..}" = "$rel" ]; then
            GENERATOR="core" process generate "./${rel#./}"
        else println "Error: invalid path: $path" >&2; fi
    done
    if [ "$#" = 0 ]; then try post_hook :; fi
}

main "$@"
