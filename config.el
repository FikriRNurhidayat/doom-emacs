;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Fikri Rahmat Nurhidayat"
      user-mail-address "fikrirnurhidayat@gmail.com")

(setq doom-font
      (font-spec :family "Iosevka Fixed" :size 16)

      doom-big-font
      (font-spec :size 32)

      doom-variable-pitch-font
      (font-spec :family "Iosevka Aile" :size 16 :weight 'normal)

      doom-unicode-font
      (font-spec :family "JuliaMono")

      doom-serif-font
      (font-spec :family "Iosevka Etoile" :weight 'normal))

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic)
  `(org-indent :inherit fixed-pitch :foreground ,(face-attribute 'default :background)))

(setq display-line-numbers-type 'relative)

(setq doom-theme 'doom-nord)

(defun +doom-remove-annoying-visual ()
  "Remove border, fringe, and so on."
  (dolist (face '(window-divider
                  window-divider-first-pixel
                  window-divider-last-pixel
                  fringe))
    (custom-set-faces! `(,face :foreground ,(face-attribute 'default :background)))))

;; TODO: Find what hook should we attach so this will always be properly executed
(add-to-list 'doom-load-theme-hook '+doom-remove-annoying-visual)

(setq inhibit-message nil
      echo-keystrokes nil
      message-log-max 100)

(use-package! doom-modeline
  :config
  (setq doom-modeline-hud nil
        doom-modeline-icon t
        doom-modeline-window-width-limit nil
        doom-modeline-height 48
        doom-modeline-major-mode-icon nil
        doom-modeline-number-limit 99
        doom-modeline-lsp nil))

(after! doom (custom-set-faces!
               `(mode-line :background ,(face-attribute 'default :background))
               `(mode-line-inactive :background ,(face-attribute 'default :background))
               `(doom-modeline-bar :background ,(face-attribute 'default :background))
               `(doom-modeline-bar-inactive :background ,(face-attribute 'default :background))))

(setq evil-want-fine-undo t         ; Be more granular
      auto-save-default t           ; Make sure your work is saved
      truncate-string-ellipsis "…") ; Save some precious space

(setq mu4e-view-prefer-html nil
      mu4e-html2text-command "html2text -utf8 -width 72")
(with-eval-after-load "mm-decode"
  (add-to-list 'mm-discouraged-alternatives "text/html")
  (add-to-list 'mm-discouraged-alternatives "text/richtext"))

(load-file (concat doom-user-dir "lisp/splash/splash.el"))

(use-package! deft
  :init
  (setq deft-directory "/home/fain/Documents/notes/"
        deft-recursive t
        deft-file-naming-rules '((noslash . "-") (nospace . "-") (case-fn . downcase))
        deft-strip-title-regexp "\\(?:^%+\\|^#\\+title: *\\|^[#* ]+\\|-\\*-[[:alpha:]]+-\\*-\\|^Title:[	 ]*\\|#+$\\)"
        deft-open-file-hook '+deft-open-file-hook))

(load-file (concat doom-user-dir "lisp/org/org-note.el"))

(map! :leader :desc "Note" "t n" #'org-note-mode)

(defun +deft-open-file-hook ()
  (when (eq major-mode 'org-mode)
    (org-note-mode 1)))

(after! org
  (map! :leader :desc "Execute ORG Babel Block" "m E" #'org-babel-execute-src-block))

(setq org-directory "/home/fain/Documents/org/")

(setq org-clock-sound "/home/fain/Documents/bababooey.wav")

(setq org-use-property-inheritance t
      org-log-done 'time
      org-startup-indented t
      org-adapt-indentation nil
      org-indent-mode-turns-off-org-adapt-indentation t
      org-hide-leading-stars t
      org-list-allow-alphabetical t
      org-export-in-background t
      org-fold-catch-invisible-edits 'smart)

(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0)))

(use-package! org-modern
  :custom
  (org-modern-star '("•"))
  (org-modern-list '((43 . "◦") (45 . "•") (42 . "•")))
  (org-modern-hide-stars " ")
  (org-modern-keyword '(("title"       . "title:      ")
                        ("description" . "description:")
                        ("subtitle"    . "subtitle:   ")
                        ("date"        . "date:       ")
                        ("email"       . "email:      ")
                        ("author"      . "author:     ")
                        ("language"    . "language:   ")
                        ("filetags"    . "filetags:   ")
                        ("options"     . "options:    ")
                        ("name"        . "name:       ")
                        ("attr_html"   . "attr_html:  ")
                        (t . t)))
  (org-modern-block-fringe nil)
  :config
  (global-org-modern-mode))

(setq org-hide-emphasis-markers t)

(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-autolinks nil)
  ;; for proper first-time setup, `org-appear--set-elements'
  ;; needs to be run after other hooks have acted.
  (run-at-time nil nil #'org-appear--set-elements))

(custom-set-faces!
  `(org-block :inherit org-block :background ,(face-attribute 'default :background))
  `(org-block-begin-line :inherit shadow :height 0.8)
  `(org-meta-line :foreground ,(face-attribute 'shadow :foreground))
  `(org-document-info :foreground ,(face-attribute 'shadow :foreground))
  `(org-document-title :weight bold :foreground ,(face-attribute 'default :foreground)))

(setq org-pretty-entities t
      org-ellipsis "…")

(setq +org-agenda-directory (concat org-directory "agenda/"))
(setq org-agenda-files (mapcar (lambda (file)
                                 (concat +org-agenda-directory file))
                               '("INBOX.org" "PROJECTS.org" "NEXT.org" "MAYBE.org")))

(defun +org-agenda-finalize-hook ()
  "Load org agenda files and hide modeline."
  (hide-mode-line-mode 1)
  (dolist (file org-agenda-files)
    (find-file-noselect file)))

(add-hook 'org-agenda-finalize-hook #'+org-agenda-finalize-hook)

(setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                          (sequence "WAIT(w@/!)" "HOLD(h@/!)" "|" "VOID(c@/!)")))

(setq org-refile-targets '(("PROJECTS.org" :maxlevel . 3)
                             ("MAYBE.org" :level . 1)
                             ("NEXT.org" :maxlevel . 2)))

(advice-add 'org-refile :after 'org-save-all-org-buffers)

(setq org-capture-templates '(("i" "Inbox" entry (file "~/Documents/org/agenda/INBOX.org") "* TODO %i%?")
                              ("w" "Website" entry (file "~/Documents/org/agenda/INBOX.org")
                                                             "* TODO [[%:link][%:description]]\n\n %i" :immediate-finish t)))

(setq org-agenda-tags-column 0
      org-agenda-block-separator ?─
      org-agenda-time-grid
      '((daily today require-timed)
        (800 1000 1200 1400 1600 1800 2000)
        " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
      org-agenda-current-time-string
      "⭠ now ─────────────────────────────────────────────────")

(setq org-agenda-custom-commands
      '(("o" "Agenda"
         (
          (todo "TODO"
                ((org-agenda-overriding-header "To Refile")
                 (org-agenda-files '("~/Documents/org/agenda/INBOX.org"))))
          (todo "NEXT"
                ((org-agenda-overriding-header "In Progress")
                 (org-agenda-files '("~/Documents/org/agenda/PROJECTS.org"
                                     "~/Documents/org/agenda/MAYBE.org"
                                     "~/Documents/org/agenda/NEXT.org"))))
          (todo "TODO"
                ((org-agenda-overriding-header "Projects")
                 (org-agenda-files '("~/Documents/org/agenda/PROJECTS.org"))))
          (todo "TODO"
                ((org-agenda-overriding-header "One-off Tasks")
                 (org-agenda-files '("~/Documents/org/agenda/NEXT.org"))
                 (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))))
          )
          nil)))

(after! writeroom-mode
  (pushnew! writeroom--local-variables
            'display-line-numbers
            'visual-fill-column-width)
  (add-hook 'writeroom-mode-enable-hook #'+zen-prose-org-h))
  (add-hook 'writeroom-mode-disable-hook #'+zen-nonprose-org-h)

(defvar +zen-org-level-scale '((org-level-1 . 1.5)
                               (org-level-2 . 1.25)
                               (org-level-3 . 1.125)
                               (org-level-4 . 1.0)
                               (org-level-5 . 1.0)
                               (org-level-6 . 1.0)
                               (org-level-7 . 1.0)
                               (org-level-8 . 1.0))
  "Org level size remap.")

(defun +zen-prose-org-h ()
  "Reformat the current Org buffer appearance for prose."
  (when (eq major-mode 'org-mode)
    (setq-local visual-fill-column-width 72
                org-adapt-indentation nil
                org-modern-hide-stars t
                +zen-text-scale 1.0)
    (org-modern-mode 0)
    (org-indent-mode 0)
    (org-modern-mode 1)
    (setq-local face-remapping-alist (mapcar (lambda (face) `(,(car face) (:height ,(cdr face))  ,(car face))) +zen-org-level-scale))))

(defun +zen-nonprose-org-h ()
  "Reverse the effect of `+zen-prose-org'."
  (when (eq major-mode 'org-mode)
    (setq-local org-adapt-indentation nil
          org-modern-hide-stars " ")
    (org-modern-mode 0)
    (org-indent-mode 1)
    (org-modern-mode 1)
    (setq-local face-remapping-alist nil)))

(define-minor-mode +org-present-mode
  "Toggle org-present-mode."
  :lighter "+org-present-mode"
  (if +org-present-mode
      (org-present)
    (org-present-quit)))

;; TODO: Move this
(defun +org-show-block ()
  (interactive)
  (org-fold-show-all '(blocks)))

;; TODO: Move this
(defun +org-back-to-heading ()
  (interactive)
  (org-back-to-heading))

(use-package! org-present
  :hook ((org-present-mode . +org-present-enable-hook)
         (org-present-mode-quit . +org-present-disable-hook))
  :init
  (add-hook 'org-present-after-navigate-functions '+org-present-prepare-slide)
  (map! :leader :desc "Present" "t p" #'+org-present-mode)
  (map! :after org-present
        :map org-present-mode-keymap
        :desc "Focus on current heading." :n "z z" #'org-present
        :desc "Display blocks" :n "C-b" #'+org-show-block
        :desc "Go to heading" :n "z h" #'+org-back-to-heading
        :desc "Go to parent slide." :n "z t" #'+org-present-up
        :desc "Go to next slide." :n "C-l" #'+org-present-next-sibling
        :desc "Go to previous slide." :n "C-h" #'+org-present-previous-sibling))

(after! org-present
  (setq org-present-add-overlays-regex "^[[:space:]]*\\(#\\\+\\)\\(\\(\\(title\\|subtitle\\|date\\|author\\|email\\)\\\:[[:space:]]\\)\\|\\(\\([a-zA-Z]+\\(?:_[a-zA-Z]+\\)*\\).*\\)\\)")
  (defun org-present-add-overlays ()
    "Add overlays for this mode."
    (add-to-invisibility-spec '(org-present))
    (save-excursion
      ;; hide org-mode options starting with #+
      (goto-char (point-min))
      (while (re-search-forward org-present-add-overlays-regex nil t)
        (let ((end (if (org-present-show-option (match-string 2)) 2 0)))
          (org-present-add-overlay (match-beginning 1) (match-end end))))
      ;; hide stars in headings
      (if org-present-hide-stars-in-headings
          (progn (goto-char (point-min))
                 (while (re-search-forward "^\\(*+\\)" nil t)
                   (org-present-add-overlay (match-beginning 1) (match-end 1)))))
      ;; hide emphasis/verbatim markers if not already hidden by org
      (if org-hide-emphasis-markers nil
        ;; TODO https://github.com/rlister/org-present/issues/12
        ;; It would be better to reuse org's own facility for this, if possible.
        ;; However it is not obvious how to do this.
        (progn
          ;; hide emphasis markers
          (goto-char (point-min))
          (while (re-search-forward org-emph-re nil t)
            (org-present-add-overlay (match-beginning 2) (1+ (match-beginning 2)))
            (org-present-add-overlay (1- (match-end 2)) (match-end 2)))
          ;; hide verbatim markers
          (goto-char (point-min))
          (while (re-search-forward org-verbatim-re nil t)
            (org-present-add-overlay (match-beginning 2) (1+ (match-beginning 2)))
            (org-present-add-overlay (1- (match-end 2)) (match-end 2))))))))

(defun +org-present-up ()
  "Go to higher heading from current heading."
  (interactive)
  (widen)
  (org-up-heading-safe)
  (org-present-narrow)
  (org-present-run-after-navigate-functions))

(defun +org-present-next-sibling ()
  "Go to next sibling."
  (interactive)
  (widen)
  (unless (org-goto-first-child)
    (org-get-next-sibling))
  (org-present-narrow)
  (org-present-run-after-navigate-functions))

(defun +org-present--last-child ()
  "Find last child of current heading."
  (when (org-goto-sibling) (+org-present--last-child))
  (when (org-goto-first-child) (+org-present--last-child)))

(defun +org-present-previous-sibling ()
  "Go to next sibling."
  (interactive)
  (widen)
  (when (org-current-level)
    (message "KONTOL")
    (org-back-to-heading)
    (if (and (org-get-previous-sibling) (org-current-level))
        (when (org-goto-first-child)
          (+org-present--last-child))))
  (org-present-narrow)
  (org-present-run-after-navigate-functions))

(defvar +org-present-org-level-scale '((org-level-1 . 2.0)
                                       (org-level-2 . 1.25)
                                       (org-level-3 . 1.25)
                                       (org-level-4 . 1.25)
                                       (org-level-5 . 1.25)
                                       (org-level-6 . 1.25)
                                       (org-level-7 . 1.25)
                                       (org-level-8 . 1.25))
  "Org level size remap for presentation.")

(defvar +org-present-original-org-modern-hide-stars nil)
(defvar +org-present-original-org-indent-mode nil)
(defvar +org-present-original-org-modern-keyword nil)
(defvar +org-present-original-inhibit-message nil)
(defvar +org-present-original-echo-keystrokes nil)
(defvar +org-present-org-modern-keyword '(("title"       . "")
                                          ("description" . "")
                                          ("subtitle"    . "")
                                          ("date"        . "")
                                          ("author"      . "")
                                          ("email"       . "")
                                          ("language"    . "")
                                          ("options"     . "")
                                          (t . t)))

(defun +org-present-enable-hook ()
  (setq-local +org-present-original-org-modern-hide-stars org-modern-hide-stars
              +org-present-original-org-indent-mode org-indent-mode
              +org-present-original-org-modern-keyword org-modern-keyword
              +org-present-original-inhibit-message inhibit-message
              +org-present-original-echo-keystrokes echo-keystrokes)
  (org-modern-mode 0)
  (org-indent-mode 0)
  (setq-local visual-fill-column-width 128
              visual-fill-column-center-text t
              org-modern-hide-stars t
              inhibit-message t
              echo-keystrokes nil
              header-line-format " "
              org-modern-keyword +org-present-org-modern-keyword)
  (setq-local face-remapping-alist (append (mapcar (lambda (face) `(,(car face) (:height ,(cdr face))  ,(car face))) +org-present-org-level-scale)
                                           '((default (:height 1.25) default)
                                             (header-line (:height 8.0) header-line)
                                             (org-document-title (:height 2.0) org-document-title)
                                             (org-document-info (:height 1.0) org-document-info))))
  (display-line-numbers-mode 0)
  (visual-fill-column-mode 1)
  (visual-line-mode 1)
  (hide-mode-line-mode 1)
  (org-modern-mode 1)
  (mixed-pitch-mode 1)
  (evil-normal-state)
  (org-display-inline-images))

(defun +org-present-prepare-slide (buffer-name heading)
  (org-overview)
  (org-fold-show-entry)
  (org-fold-hide-block-all)
  (org-fold-hide-drawer-all))

(defun +org-present-disable-hook ()
  (setq-local header-line-format nil
              face-remapping-alist nil
              org-adapt-indentation nil
              org-modern-hide-stars +org-present-original-org-modern-hide-stars
              org-indent-mode +org-present-original-org-indent-mode
              org-modern-keyword +org-present-original-org-modern-keyword
              inhibit-message +org-present-original-inhibit-message
              echo-keystrokes +org-present-original-echo-keystrokes)
  (org-present-small)
  (visual-fill-column-mode 0)
  (org-indent-mode 1)
  (hide-mode-line-mode 0)
  (mixed-pitch-mode 0)
  (org-mode-restart)
  (org-remove-inline-images))

(use-package! org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (concat org-directory "roams/"))
  (org-roam-capture-templates
   '(("d" "Default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)))
  (org-roam-complete-everywhere t))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
    :after org-roam
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(defvar create-blog-post--replace-alist '(" " "'")
  "Cons of replace str")

(defvar create-blog-post--directory "~/Repositories/fikrirnurhidayat/content/id/"
  "Where to store blog files.")

(defun create-blog-post--slugify (title)
  (downcase (string-replace " " "-" title)))

(defun create-blog-post ()
  "Create an org file in ~/source/myblog/posts."
  (interactive)
  (let* ((title (read-string "Title: "))
         (slug (create-blog-post--slugify title))
         (directory (concat create-blog-post--directory slug)))
    (find-file (expand-file-name "index.org" directory))))

(appendq! org-export-backends '(slack))

(appendq! org-export-backends '(gfm))

(defvar +ligatures-extra-symbols
  '(:name          "»"
    :src_block     "»"
    :src_block_end "«"
    :quote         "“"
    :quote_end     "”"
    :lambda        "λ")
  "Maps identifiers to symbols, recognized by `set-ligatures'.

This should not contain any symbols from the Unicode Private Area! There is no
universal way of getting the correct symbol as that area varies from font to
font.")

(load-file (concat doom-user-dir "lisp/eshell/eshell.el"))

(use-package! projectile
  :init
  (when (and (file-directory-p "~/Works/Repositories") (file-directory-p "~/Repositories"))
    (setq projectile-project-search-path '("~/Work/Repositories" "~/Repositories" "~/Repositories/GO/src"))))

(setq geiser-repl-autodoc-p nil
      geiser-mode-autodoc-p nil)
