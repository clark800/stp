
h1_pages() {
    # use distinctive casing (</dIv>) to avoid removing pre-existing </div>
    sed '1i\
<div class="pages">
' | sed 's|^<h1>|</dIv>\
<div class="page">\
<h1>|' |
    sed -e '1,/^<\/dIv>/{/^<\/dIv>/d' -e '}' |
    sed 's|^</dIv>|</div>|' |
    sed '$a\
</div>\
</div>
'
}
