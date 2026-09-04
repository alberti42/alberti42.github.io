---
title: "Publishing this site from Org with ox-hugo"
author: ["Andrea Alberti"]
description: "How the Org sources in content-org/ become the Markdown that Hugo builds."
date: 2026-08-29T00:00:00+02:00
tags: ["org-mode", "hugo", "publishing"]
draft: false
---

This site is written in Org and built by [Hugo](https://gohugo.io). Nothing in `content/` is
edited by hand: every post is composed as an `.org` file under `content-org/`,
and [ox-hugo](https://ox-hugo.scripter.co) exports it to Hugo-flavored Markdown.


## Why not simply have Hugo read the Org files directly? {#why-not-simply-have-hugo-read-the-org-files-directly}

Hugo _can_ parse `.org` natively, through a Go reimplementation of the Org
syntax. It handles the common cases, but it is not Org's own exporter, so it
quietly does not understand `#+INCLUDE`, Babel results, macros, or link
abbreviations.

ox-hugo works differently: it runs the real Org exporter inside Emacs and emits
Markdown. Hugo then only ever sees Markdown, and every Org feature keeps
working.


## The layout {#the-layout}

```text
content-org/emacs/this-file.org   ->   content/emacs/this-file.md
```

Three keywords do the routing:

`#+HUGO_BASE_DIR`
: where the Hugo site root is, relative to the Org file.

`#+HUGO_SECTION`
: which section the post belongs to, and therefore its URL.

`#+EXPORT_FILE_NAME`
: the slug.

Tags come from `#+HUGO_TAGS`. Note that `#+FILETAGS` does _not_ work in the
one-file-per-post flow (that is a subtree-flow feature).


## Exporting {#exporting}

From inside the buffer, `C-c C-e H H` exports the current file. To rebuild
everything from a shell:

```sh
make export      # org  -> content/*.md
make serve       # live-reloading preview on :1313
```


## Code blocks keep their highlighting {#code-blocks-keep-their-highlighting}

```emacs-lisp
(use-package ox-hugo
  :after ox
  :custom (org-hugo-front-matter-format "yaml"))
```

That is the whole pipeline: it produces Markdown files in `content/` as a build
artifact that happens to be committed, so CI does not need Emacs.
