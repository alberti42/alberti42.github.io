---
title: "Publishing this site from Org with ox-hugo"
author: ["Andrea Alberti"]
description: "How the Org sources in content-org/ become the Markdown that Hugo builds."
date: 2026-08-29T00:00:00+02:00
tags: ["org-mode", "hugo", "publishing"]
draft: false
---

This site is written in Org and built by [Hugo](https://gohugo.io). Every post is composed as `.org`
file under `content-org/`, and [ox-hugo](https://ox-hugo.scripter.co) exports it to Hugo-flavored
Markdown. Org notes are automatically exported to `content/`.


## Setting meta information (title, tags) and decide routing {#setting-meta-information--title-tags--and-decide-routing}

```text
content-org/emacs/this-file.org -> content/emacs/this-file.md
```

Three keywords do the routing:

`#+HUGO_BASE_DIR`
: where the Hugo site root is, relative to the Org file.

`#+HUGO_SECTION`
: which section the post belongs to, and therefore its URL.

`#+EXPORT_FILE_NAME`
: the slug used in the site (e.g., for this document
    `publishing-this-site-from-org`).

Tags come from `#+HUGO_TAGS`. Since [PR #492](https://github.com/kaushalmodi/ox-hugo/pull/492), one can in principle also use the
alternative fallback syntax `#+FILETAGS`, which is the familiar keyword if one
is used to write org notes.


## How the export procedure works {#how-the-export-procedure-works}


### ox-hugo vs. Hugo org exporter {#ox-hugo-vs-dot-hugo-org-exporter}

Hugo _can_ parse `.org` natively, through a Go reimplementation of the Org
syntax. It handles the common cases, but it is not Org's own exporter, so it
has several limitations. It fails to

-   understand keywords such as `#+INCLUDE`,
-   export Babel results,
-   recognize macros,
-   or link abbreviations.

Instead, [ox-hugo](https://ox-hugo.scripter.co/) works differently: it relies on the real Org exporter inside
Emacs and produces Markdown files. Hugo then only ever sees Markdown. This
workflow ensures the best coverage of the org-mode features.


### Two ways to trigger the export {#two-ways-to-trigger-the-export}

From inside the buffer, `C-c C-e H H` exports the current file. Instead, to
rebuild everything from a shell, I rely on a [Makefile](https://github.com/alberti42/alberti42.github.io/blob/main/Makefile):

```sh
make export
make serve # live preview on :1313
```


## What is cool about this workflow {#what-is-cool-about-this-workflow}


### Code blocks keep their highlighting {#code-blocks-keep-their-highlighting}

```emacs-lisp
(use-package ox-hugo :after ox :custom (org-hugo-front-matter-format "yaml"))
```


### Math equations are rendered as selectable MathML text {#math-equations-are-rendered-as-selectable-mathml-text}

LaTeX equations are rendered directly at build time into [MathML](https://en.wikipedia.org/wiki/MathML), styled using
KaTeX CSS stylesheets. The conversion is done by Hugo's embedded KaTeX
exporter.

\[ E=mc^2 \]

This ensures that the website does not require any JavaScript to be transposed
to KaTeX-styled MathML, since all conversions already happen at build time.

Furthermore, equations are rendered as selectable text, thus avoiding linking
SVG files, which cannot be easily parsed by search engines.


## About the template and look {#about-the-template-and-look}

The website look is not glamorous but functional. It is based on Hugo's [Congo](https://github.com/jpanther/congo)
template. In addition, there is a bunch of local customizations on top of the template via:

`layouts/`
: it shadows the theme's own layout,

`assets/css/custom.css`
: this is appended by Congo after its own CSS.

To update the template:

```sh
make theme-update
```

All config files live under `config/_default`.


## Concluions {#concluions}

That is the whole pipeline. The workflow is kept rather simple. It produces
Markdown files in `content/` as a build artifact, which are then committed, so
the GitHub [CI](https://github.com/alberti42/alberti42.github.io/blob/main/.github/workflows/hugo.yml) does not need Emacs.
