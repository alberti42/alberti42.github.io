;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

;; Project environment for the Jekyll site.  Homebrew's Ruby must shadow
;; /usr/bin/ruby, otherwise `bundle exec jekyll' fails.  The Makefile already
;; fixes PATH on its own, so what follows matters for everything else Emacs
;; may start here (M-x shell-command, inf-ruby, flycheck, ...).
;;
;; The `eval' form is not a known-safe local variable: Emacs asks once per
;; session when a file in this tree is first visited.  Answer `!' to record it
;; in `safe-local-variable-values' and stop being asked.

((nil
  . ((compile-command . "make ")

     (eval
      . (let* ((brew (or (getenv "HOMEBREW_PREFIX") "/opt/homebrew"))
               (ruby-bin (expand-file-name "opt/ruby/bin" brew)))
          (when (file-directory-p ruby-bin)
            (let ((path (concat ruby-bin ":" (getenv "PATH"))))
              ;; M-x compile / M-x recompile
              (setq-local compilation-environment
                          (list (concat "PATH=" path)
                                "JEKYLL_ENV=development"
                                ;; Jekyll reads UTF-8 sources; a GUI Emacs
                                ;; started from Finder has no locale set.
                                "LC_ALL=en_US.UTF-8"
                                "LANG=en_US.UTF-8"))
              ;; Any other subprocess started from a buffer in this tree
              (setq-local process-environment
                          (append (list (concat "PATH=" path)
                                        "LC_ALL=en_US.UTF-8"
                                        "LANG=en_US.UTF-8")
                                  process-environment))
              (setq-local exec-path (cons ruby-bin exec-path))))))

     ;; Editing conventions carried over from alberti42.sublime-project
     (indent-tabs-mode . nil)
     (tab-width . 2)
     (require-final-newline . t)))

 ;; Tabs are significant in a Makefile
 (makefile-mode . ((indent-tabs-mode . t))))
