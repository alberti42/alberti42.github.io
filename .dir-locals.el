;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

;; Project environment for the Hugo site.
;;
;; Two things happen here:
;;
;;   1. Homebrew's bin directory is put on PATH, so `M-x compile' (and any
;;      other subprocess started from this tree) can find `hugo'.
;;
;;   2. The repo-local ox-hugo installed by `make export' is added to
;;      `load-path', and scripts/ox-hugo-settings.el is loaded.  That makes
;;      C-c C-e H H inside a content-org/ buffer produce byte-for-byte the
;;      same Markdown as `make export', without ox-hugo having to be part of
;;      your personal Emacs configuration.
;;
;; The `eval' form is not a known-safe local variable: Emacs asks once per
;; session when a file in this tree is first visited.  Answer `!' to record it
;; in `safe-local-variable-values' and stop being asked.

((nil
  . ((compile-command . "make ")

     (eval
      . (let* ((root (locate-dominating-file
                      (or buffer-file-name default-directory) ".dir-locals.el"))
               (brew (or (getenv "HOMEBREW_PREFIX") "/opt/homebrew"))
               (brew-bin (expand-file-name "bin" brew)))

          (when (file-directory-p brew-bin)
            (let ((path (concat brew-bin ":" (getenv "PATH"))))
              ;; M-x compile / M-x recompile
              (setq-local compilation-environment
                          (list (concat "PATH=" path)
                                ;; A GUI Emacs started from Finder has no
                                ;; locale set; Hugo and Org both read UTF-8.
                                "LC_ALL=en_US.UTF-8"
                                "LANG=en_US.UTF-8"))
              ;; Any other subprocess started from a buffer in this tree
              (setq-local process-environment
                          (append (list (concat "PATH=" path)
                                        "LC_ALL=en_US.UTF-8"
                                        "LANG=en_US.UTF-8")
                                  process-environment))
              (setq-local exec-path (cons brew-bin exec-path))))

          (when root
            (let ((pkgs (expand-file-name ".emacs-packages" root)))
              (when (file-directory-p pkgs)
                (dolist (dir (directory-files pkgs t "\\`[^.]"))
                  (when (file-directory-p dir)
                    (add-to-list 'load-path dir)))))
            (when (require 'ox-hugo nil :noerror)
              (load (expand-file-name "scripts/ox-hugo-settings.el" root)
                    :noerror :nomessage)))))

     ;; Editing conventions carried over from alberti42.sublime-project
     (indent-tabs-mode . nil)
     (tab-width . 2)
     (require-final-newline . t)))

 ;; Tabs are significant in a Makefile
 (makefile-mode . ((indent-tabs-mode . t))))
