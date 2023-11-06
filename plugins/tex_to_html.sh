# this strips some lines containing some latex commands that frequently
# appear in latex headers, but it won't work properly if the commands span
# multiple lines and it won't catch all possible header commands

tex_to_html() {
    grep -F -v -e '\input{' -e '\include{' \
        -e '\usepackage{' -e '\usepackage[' \
        -e '\documentclass{' -e '\documentclass{' \
        -e '\pagestyle{' -e '\thispagestyle{' -e '\setlength{' \
        -e '\title{' -e '\author{' -e '\thanks{' -e '\date{' \
        -e '\begin{document}' -e '\end{document}' |
    sed -e 's|^$|<p>|' -e 's|``|\&ldquo;|g' -e "s|''|\\&rdquo;|g" \
        -e 's|\\textbf{\([^}]*\)}|<b>\1</b>|g' \
        -e 's|\\textit{\([^}]*\)}|<i>\1</i>|g' \
        -e 's|\\h{\([^}]*\)}|<sup><a href="\1">*</a></sup>|g' \
        -e 's|\\url{\([^}]*\)}|<a href="\1">\1</a>|' \
        -e 's|\\href{\([^}]*\)}{\([^}]*\)}|<a href="\1">\2</a>|' \
        -e "s|\\\\maketitle|<h1>$TITLE</h1>|" \
        -e 's|\\part{\([^}]*\)}|<h1>\1</h1>|' \
        -e 's|\\chapter{\([^}]*\)}|<h1>\1</h1>|' \
        -e 's|\\section{\([^}]*\)}|<h2>\1</h2>|' \
        -e 's|\\subsection{\([^}]*\)}|<h3>\1</h3>|' \
        -e 's|\\subsubsection{\([^}]*\)}|<h4>\1</h4>|' \
        -e 's|\\begin{itemize}|<ul>|' \
        -e 's|\\end{itemize}|</ul>|' \
        -e 's|\\begin{enumerate}|<ol>|' \
        -e 's|\\end{enumerate}|</ol>|' \
        -e 's|\\item|<li>|' \
        -e 's|\\begin{quote}|<blockquote>|' \
        -e 's|\\end{quote}|</blockquote>|' \
        -e 's|\\begin{center}|<center>|' \
        -e 's|\\end{center}|</center>|' \
        -e 's|\\begin{tabular}|\\begin{array}|' \
        -e 's|\\end{tabular}|\\end{array}|'
}
