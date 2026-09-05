;;; new-post-scratch.el --- unsaved Org buffer for a not-yet-placed post  -*- lexical-binding: t; -*-

;; Loaded via `emacsclient --eval' from `make new-post' when it is invoked
;; without SECTION/SLUG.  Prefills a fresh, file-less Org buffer with
;; archetypes/post.org so a post can be drafted before its section and slug
;; are decided.  Nothing is written to disk here: save the buffer yourself
;; (`C-x C-w') as content-org/<section>/<slug>.org once you know where it
;; belongs.

(let* ((root (expand-file-name ".."
                               (file-name-directory
                                (or load-file-name buffer-file-name))))
       (template (expand-file-name "archetypes/post.org" root))
       (date (format-time-string "<%Y-%m-%d>"))
       (buf (generate-new-buffer "*new-post*")))
  (with-current-buffer buf
    (insert-file-contents template)
    (goto-char (point-min))
    (while (search-forward "@DATE" nil t)
      (replace-match date t t))
    (org-mode)
    (goto-char (point-min))
    (re-search-forward "@TITLE" nil t)
    (goto-char (match-beginning 0))
    (set-buffer-modified-p nil))
  (switch-to-buffer buf))

;;; new-post-scratch.el ends here
