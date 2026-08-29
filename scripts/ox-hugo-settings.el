;;; ox-hugo-settings.el --- Shared ox-hugo settings for this site  -*- lexical-binding: t; -*-

;; Loaded both by scripts/ox-hugo-export.el (batch, `make export') and by
;; .dir-locals.el (interactive, C-c C-e H H), so that a post exports
;; identically either way.

(require 'ox-hugo)

;; YAML front matter reads better than TOML in a diff; Hugo accepts both.
(setq org-hugo-front-matter-format "yaml")

;; ---------------------------------------------------------------------------
;; Maths: emit LaTeX byte-for-byte
;; ---------------------------------------------------------------------------
;;
;; By default ox-hugo runs `org-blackfriday-escape-chars-in-equation' over
;; every fragment, rewriting \( as \\( and _ as \_ .  That was necessary when
;; Hugo used Blackfriday and, later, for Goldmark *without* the passthrough
;; extension -- in both, a bare \( is consumed as an escaped parenthesis
;; before any maths renderer sees it.
;;
;; This site enables Goldmark's passthrough extension (Congo turns it on) and
;; renders maths at build time with Hugo's embedded KaTeX, in
;; layouts/_markup/render-passthrough.html.  Passthrough matches its
;; delimiters before escape processing, so ox-hugo's escaping now corrupts the
;; maths rather than protecting it.  Overriding the two transcoders is the
;; smallest way to switch it off; `#+OPTIONS: tex:verbatim' is not enough,
;; because the backslashes get doubled further down the pipeline.
;;
;; ox-hugo has no passthrough-aware option as of 2025-12; revisit if one lands.

(defun site/org-hugo-latex-fragment (fragment _contents _info)
  "Transcode FRAGMENT to Markdown unchanged, for Goldmark passthrough.
Covers \\(...\\), \\[...\\] and $$...$$."
  (org-element-property :value fragment))

(defun site/org-hugo-latex-environment (environment _contents _info)
  "Transcode ENVIRONMENT unchanged, wrapped in \\[...\\].
The wrapping is what lets a bare \\begin{align} block in Org be picked up by
Goldmark's passthrough extension, which keys off the delimiters."
  (format "\\[\n%s\n\\]"
          (string-trim
           (org-remove-indentation (org-element-property :value environment)))))

(advice-add 'org-blackfriday-latex-fragment
            :override #'site/org-hugo-latex-fragment)
(advice-add 'org-blackfriday-latex-environment
            :override #'site/org-hugo-latex-environment)

(provide 'ox-hugo-settings)
;;; ox-hugo-settings.el ends here
