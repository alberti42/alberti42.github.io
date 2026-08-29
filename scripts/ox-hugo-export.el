;;; ox-hugo-export.el --- Batch-export content-org/ to content/  -*- lexical-binding: t; -*-

;; Exports every .org file under content-org/ to Hugo-flavoured Markdown in
;; content/, without touching your personal Emacs configuration: ox-hugo and
;; its dependencies are installed into .emacs-packages/ inside this repo,
;; which is gitignored.
;;
;; Run it with `make export'.  Interactively you would instead hit C-c C-e H H
;; in the buffer -- see the ox-hugo block in .dir-locals.el, which applies the
;; same settings to your own Emacs session.

(require 'package)

(defconst site-root
  (expand-file-name
   ".." (file-name-directory (or load-file-name buffer-file-name default-directory)))
  "Repository root, i.e. the Hugo site root.")

(setq package-user-dir (expand-file-name ".emacs-packages" site-root)
      package-archives '(("gnu"    . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa"  . "https://melpa.org/packages/"))
      make-backup-files nil
      create-lockfiles nil
      org-confirm-babel-evaluate nil)

(package-initialize)
(unless (package-installed-p 'ox-hugo)
  (message "==> installing ox-hugo into %s" package-user-dir)
  (package-refresh-contents)
  (package-install 'ox-hugo))

(require 'ox-hugo)
(load (expand-file-name "scripts/ox-hugo-settings.el" site-root))

(let ((files (directory-files-recursively
              (expand-file-name "content-org" site-root) "\\.org\\'"))
      (exported 0))
  (unless files
    (message "no .org files under content-org/ -- nothing to do"))
  (dolist (file files)
    (with-current-buffer (find-file-noselect file)
      (message "  %s" (file-relative-name file site-root))
      ;; One .org file per post: export the whole file, not a subtree.
      (org-hugo-export-to-md)
      (setq exported (1+ exported))
      (kill-buffer)))
  (message "==> exported %d file(s) to content/" exported))

;;; ox-hugo-export.el ends here
