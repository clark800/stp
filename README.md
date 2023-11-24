stp
===

`stp` (shell template processor) is an extensible static site generator and generic template processor in 100 lines of POSIX shell. Plugins for automatic generation of navigation links, index files, etc are another couple hundred lines.

Summary of features:
* Dynamic template engine based on shell command substitution (no new syntax)
* Recursive template instantiation
* Supports both source templates (e.g. markdown) and target templates (e.g. html)
* Extensible with plugins for template functions, output transformations, and generators
* Supports any combination of input formats and output formats
* The default configuration generates semantic HTML5 with classless CSS and no Javascript from a directory of markdown files


Quick Start
-----------
If you have a directory of markdown files, this will generate an HTML page for each markdown file in the same directory as the markdown file.

1. Install the [smd](https://github.com/clark800/smd) markdown renderer.
2. In the `stp` directory, run `sudo ./make install`
3. `cp -r stp/config <your-markdown-directory>/.stp`
4. `cd <your-markdown-directory>`
5. `stp`

If you want to use another markdown processor you can replace `smd` in the `md.to.html` template.

You can add `=` annotations to markdown files if you want index files to show dates:

```
Title
=====
= published: 2023-09-30
= tags: blog

Main content
```

Another option is manually writing `index.md` files which provides more flexibility and doesn't require `=` annotations.


How it works
------------
The main idea of `stp` is to use shell command substitution and parameter expansion to instantiate templates. It does this by automatically escaping double quotes and backticks in the input, then `eval`ing a `printf` with the input placed inside shell script double quotes. The actual instantiation code is one line:

```shell
eval "printf '%s\\n' \"$(sed 's/\\*\(["`]\)/\\\1/g' "$path")\""
```

This is a simplified markdown to HTML template:

```html
<html>
<head>
<meta name="generator" content="stp:$GENERATOR">
<title>$TITLE</title>
<link rel="stylesheet" href="/.stp/styles/default.css">
</head>
<body>
<header>
$(breadcrumb)
</header>
$(input | smd)
</body>
</html>
```

Instantiation will substitute the value of the shell variables for `GENERATOR` and `TITLE`, and run the code in the `$()` brackets, substituting the output into the template. The `input` function prints the contents of the current source file being processed, which is then stripped of metadata annotations with `grep`, then processed with the `smd` markdown processor to fill in the main content.


Recursive templates
-------------------
Templates can recursively instantiate other templates, which allows you to extract common parts like headers and footers. The above template could be refactored to:

```html
$(instantiate header)
$(input | smd)
$(instantiate footer)
```

Now the `header` and `footer` templates can be reused in other templates.


Source templates
----------------
The templates above are target templates. We can also treat the source files as templates by replacing `input` with `instantiate`:

```html
$(instantiate header)
$(instantiate | smd)
$(instantiate footer)
```

Now you can process a markdown file that looks like this:

```
Article Title
=============
Intro text

$(table_of_contents_md)

Main content here
```


Plugins
-------
Any `.sh` shell script you place in the `.stp/plugins` directory will be automatically imported when you run `stp` and any functions imported from plugins will be available in all templates.

To avoid conflicts between plugins, each plugin should only define one top-level function and the name should be the same as the filename without the `.sh` extension. Additional functions can be defined nested inside the top-level function starting with an underscore, which ensures they don't interfere with any top-level functions.
