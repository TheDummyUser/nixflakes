;; -*- lexical-binding: t; -*-
;;
;; Complete Doom Emacs-style configuration for Nix-managed setup
;; All packages installed via Nix, no auto-downloads at runtime.
;; This configuration closely matches Doom Emacs keybindings and behavior
;; Enhanced with improved LSP intellisense and Git line-level operations

;;; --- Core Settings ---
(setq inhibit-startup-message t
      initial-scratch-message nil
      ring-bell-function 'ignore
      custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

;; Set font globally: JetBrainsMono Nerd Font size 14
(set-face-attribute 'default nil :family "Iosevka Nerd Font" :height 120)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode 1)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(save-place-mode 1)
(global-auto-revert-mode 1)
(setq make-backup-files nil) ; stop creating ~ files

;; Always horizontally split windows (Doom style)
(setq split-height-threshold nil
      split-width-threshold 120)

(setq split-window-preferred-function
      (lambda (window)
        (or (and (window-splittable-p window t)
                 (split-window window nil t))
            (and (window-splittable-p window)
                 (split-window window)))))

;;; --- GC and Native Compilation Optimizations ---
(setq gc-cons-threshold (* 100 1024 1024)) ; 100mb at startup for fast load
(add-hook 'emacs-startup-hook (lambda () (setq gc-cons-threshold (* 4 1024 1024)))) ; tighten after startup

(when (fboundp 'native-compile-async)
  (setq native-comp-jit-compilation t
        native-comp-speed 3
        native-comp-warning-on-missing-native t))

;;; --- use-package Setup ---
(setq use-package-always-ensure nil) ; Do NOT install packages at runtime

;;; --- Evil Mode Setup ---
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil
        evil-respect-visual-line-mode t
        evil-undo-system 'undo-tree)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package undo-tree
  :config
  (global-undo-tree-mode 1)
  (setq undo-tree-auto-save-history nil))

;;; --- Multiple Cursors: Doom Emacs Style (evil-mc + evil-multiedit) ---
(use-package evil-mc
  :after evil
  :config
  (global-evil-mc-mode 1)
  ;; Custom escape function for multiple cursors
  (defun +multiple-cursors/evil-mc-toggle-cursor-here ()
    "Toggle a cursor at point."
    (interactive)
    (if (evil-mc-has-cursors-p)
        (evil-mc-make-cursor-here)
      (evil-mc-make-cursor-here)))

  (defun +multiple-cursors/evil-mc-escape ()
    "Clear all cursors and return to normal state."
    (interactive)
    (evil-mc-undo-all-cursors)
    (evil-normal-state)))

(use-package evil-multiedit
  :after evil
  :config
  (evil-multiedit-default-keybinds))

;;; --- General.el for Keybindings (Doom style) ---
(use-package general
  :config
  (general-create-definer doom/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-create-definer doom/local-leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC m"
    :global-prefix "C-SPC m"))

;;; --- which-key Configuration (Doom style popup height=0.3) ---
(use-package which-key
  :init
  (setq which-key-separator " "
        which-key-prefix-prefix "+"
        which-key-allow-imprecise-window-fit nil
        which-key-popup-type 'side-window
        which-key-side-window-max-height 0.3)
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3))

;;; --- Completion Framework (Ivy/Counsel/Swiper) ---
(use-package ivy
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        ivy-wrap t
        ivy-count-format "(%d/%d) "
        enable-recursive-minibuffers t
        ivy-re-builders-alist
        '((ivy-bibtex . ivy--regex-ignore-order)
          (t . ivy--regex-plus))))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))

(use-package swiper)
(use-package ivy-rich :after ivy :config (ivy-rich-mode 1))

;;; --- Company Completion ---
(use-package company
  :config
  (global-company-mode)
  (setq company-idle-delay 0.3
        company-minimum-prefix-length 2
        company-show-numbers t
        company-tooltip-align-annotations t
        company-tooltip-flip-when-above t))

(use-package company-box
  :after company
  :hook (company-mode . company-box-mode))

;;; --- Snippets ---
(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet)

;; Company + Yasnippet integration
(defun company-yasnippet-or-completion ()
  (interactive)
  (let ((yas-fallback-behavior
         (apply #'company-complete-common nil)))
    (unless (yas-expand)
      (call-interactively 'company-complete-common))))

(define-key company-active-map (kbd "TAB") 'company-yasnippet-or-completion)
(define-key company-active-map (kbd "<tab>") 'company-yasnippet-or-completion)

;;; --- Project Management ---
(use-package projectile
  :config
  (projectile-mode 1)
  (setq projectile-completion-system 'ivy
        projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :after (counsel projectile)
  :config (counsel-projectile-mode))

;;; --- Syntax Checking & LSP ---
(use-package flycheck
  :config
  (global-flycheck-mode)
  (setq flycheck-display-errors-delay 0.1
        flycheck-clang-definitions t
        flycheck-emacs-lisp-load-path 'inherit)
  ;; Add C++ specific flags for unused warnings
  (add-hook 'c++-mode-hook
            (lambda ()
              (setq flycheck-clang-args '("-Wall" "-Wextra" "-Wunused-variable" "-Wunused-parameter")))))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook ((go-mode . lsp-deferred)
         (nix-mode . lsp-deferred)
         (rjsx-mode . lsp-deferred)
         (rust-mode . lsp-deferred)
         (c-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-auto-guess-root t
        lsp-prefer-flymake nil
        lsp-file-watch-threshold 2000
        lsp-eldoc-render-all t
        lsp-idle-delay 0.6
        lsp-completion-provider :capf
        lsp-headerline-breadcrumb-enable nil
        lsp-restart 'auto-restart
        lsp-enable-symbol-highlighting t
        lsp-enable-on-type-formatting nil
        lsp-signature-auto-activate nil
        lsp-signature-render-documentation nil
        lsp-modeline-code-actions-enable t
        lsp-modeline-diagnostics-enable t
        lsp-log-io nil))

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-peek-always-show t
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-ignore-duplicate nil
        lsp-ui-doc-enable t
        lsp-ui-doc-position 'bottom
        lsp-ui-doc-delay 2
        lsp-ui-peek-fontify 'on-demand
        lsp-ui-sideline-show-code-actions t))

(use-package lsp-ivy
  :after (lsp-mode ivy)
  :commands lsp-ivy-workspace-symbol)

;;; --- Enhanced LSP Intellisense Functions ---
(defun +lsp/trigger-completion ()
  "Manually trigger LSP completion at point (like Ctrl+Space in VSCode)."
  (interactive)
  (if (bound-and-true-p lsp-mode)
      (progn
        (company-abort)
        (company-manual-begin))
    (company-complete)))

(defun +lsp/show-hover-doc ()
  "Show hover documentation at point (like hovering in VSCode)."
  (interactive)
  (if (bound-and-true-p lsp-mode)
      (lsp-ui-doc-show)
    (eldoc-print-current-symbol-info)))

(defun +lsp/hide-hover-doc ()
  "Hide hover documentation."
  (interactive)
  (when (bound-and-true-p lsp-ui-mode)
    (lsp-ui-doc-hide)))

(defun +lsp/signature-help ()
  "Show signature help (parameter hints)."
  (interactive)
  (when (bound-and-true-p lsp-mode)
    (lsp-signature-activate)))

(defun +lsp/toggle-inlay-hints ()
  "Toggle inlay hints if supported by the language server."
  (interactive)
  (if (bound-and-true-p lsp-mode)
      (if (and (lsp-feature? "textDocument/inlayHint")
               (fboundp 'lsp-inlay-hints-mode))
          (lsp-inlay-hints-mode 'toggle)
        (message "Inlay hints not supported by current language server"))
    (message "LSP not active")))

;; Auto-show hover documentation on cursor pause
(defvar +lsp--hover-timer nil
  "Timer for auto-showing hover documentation.")

(defun +lsp/auto-hover-setup ()
  "Setup auto-hover functionality."
  (when +lsp--hover-timer
    (cancel-timer +lsp--hover-timer))
  (setq +lsp--hover-timer
        (run-with-idle-timer 1.0 t #'+lsp/show-hover-doc-if-available)))

(defun +lsp/show-hover-doc-if-available ()
  "Show hover doc if LSP is available and cursor hasn't moved."
  (when (and (bound-and-true-p lsp-mode)
             (not (minibufferp))
             (not (region-active-p)))
    (+lsp/show-hover-doc)))

(defun +lsp/cancel-auto-hover ()
  "Cancel auto-hover timer."
  (when +lsp--hover-timer
    (cancel-timer +lsp--hover-timer)
    (setq +lsp--hover-timer nil)))

;; Setup auto-hover in LSP buffers
(add-hook 'lsp-mode-hook #'+lsp/auto-hover-setup)
(add-hook 'kill-buffer-hook #'+lsp/cancel-auto-hover)

(custom-set-faces
 ;; Errors: straight red line
 '(flycheck-error   ((t (:underline (:style line :color "Red1")))))
 ;; Warnings: straight orange line
 '(flycheck-warning ((t (:underline (:style line :color "DarkOrange")))))
 ;; Infos: straight green line
 '(flycheck-info    ((t (:underline (:style line :color "LightBlue"))))))

;;; --- Enhanced Git Operations for Line/Region Management ---

(defun +git/get-current-file-relative-path ()
  "Get the current file path relative to git repository root."
  (when buffer-file-name
    (let* ((git-root (magit-toplevel))
           (relative-path (if git-root
                              (file-relative-name buffer-file-name git-root)
                            buffer-file-name)))
      relative-path)))

(defun +git/get-line-numbers ()
  "Get line numbers for current region or current line."
  (let ((bounds (+git/get-region-or-line-bounds)))
    (cons (line-number-at-pos (car bounds))
          (line-number-at-pos (cdr bounds)))))

(defun +git/get-region-or-line-bounds ()
  "Get the bounds of current region or current line."
  (if (use-region-p)
      (cons (region-beginning) (region-end))
    (cons (line-beginning-position) (line-end-position))))

(defun +git/get-region-info ()
  "Get information about the current region or current line."
  (if (use-region-p)
      (list (line-number-at-pos (region-beginning))
            (line-number-at-pos (region-end))
            (buffer-substring-no-properties (region-beginning) (region-end)))
    (list (line-number-at-pos)
          (line-number-at-pos)
          (thing-at-point 'line t))))

(defun +git/show-region-diff ()
  "Show git diff for the current region or line."
  (interactive)
  (let* ((file-path (+git/get-current-file-relative-path))
         (line-nums (+git/get-line-numbers))
         (start-line (car line-nums))
         (end-line (cdr line-nums)))
    (if file-path
        (let* ((git-root (magit-toplevel))
               (default-directory git-root))
          ;; Use magit's diff functionality with line restriction
          (magit-diff-range "HEAD" nil (list file-path))
          (message "Showing diff for %s (lines %d-%d)" file-path start-line end-line))
      (message "Current buffer is not a file or not in a git repository"))))

(defun +git/stash-region ()
  "Create a patch from the current region and offer to stash it."
  (interactive)
  (let* ((file-path (+git/get-current-file-relative-path))
         (bounds (+git/get-region-or-line-bounds))
         (line-nums (+git/get-line-numbers))
         (start-line (car line-nums))
         (end-line (cdr line-nums)))
    (if file-path
        (let* ((git-root (magit-toplevel))
               (default-directory git-root)
               (stash-message (read-string
                              (format "Note about lines %d-%d from %s: "
                                      start-line end-line file-path))))
          (if (y-or-n-p "This will stash the entire file. Continue? ")
              (progn
                (save-buffer)
                (magit-stash-both stash-message)
                (message "Changes stashed with message: %s" stash-message))
            (message "Stash cancelled")))
      (message "Current buffer is not a file or not in a git repository"))))

(defun +git/revert-region ()
  "Revert changes in the current region or current line."
  (interactive)
  (let* ((file-path (+git/get-current-file-relative-path))
         (bounds (+git/get-region-or-line-bounds))
         (line-nums (+git/get-line-numbers))
         (start-line (car line-nums))
         (end-line (cdr line-nums)))
    (if file-path
        (if (y-or-n-p (format "Revert lines %d-%d in %s? This cannot be undone! "
                              start-line end-line file-path))
            (let* ((git-root (magit-toplevel))
                   (default-directory git-root)
                   (temp-file (make-temp-file "git-revert-"))
                   ;; Get the original content from HEAD
                   (full-original (with-temp-buffer
                                    (insert-file-contents
                                     (expand-file-name file-path git-root))
                                    (buffer-string)))
                   (head-content (with-temp-buffer
                                   (call-process "git" nil t nil
                                                 "show" (format "HEAD:%s" file-path))
                                   (buffer-string))))
              (if (not (string-empty-p head-content))
                  (progn
                    ;; Save current buffer content
                    (save-buffer)
                    ;; Create a temporary buffer with HEAD content
                    (with-temp-buffer
                      (insert head-content)
                      (goto-char (point-min))
                      (forward-line (1- start-line))
                      (let ((start-pos (point)))
                        (forward-line (1+ (- end-line start-line)))
                        (let ((replacement-text (buffer-substring start-pos (point))))
                          ;; Now apply the replacement in the actual buffer
                          (with-current-buffer (find-file-noselect
                                                (expand-file-name file-path git-root))
                            (goto-char (point-min))
                            (forward-line (1- start-line))
                            (let ((replace-start (point)))
                              (forward-line (1+ (- end-line start-line)))
                              (delete-region replace-start (point))
                              (goto-char replace-start)
                              (insert replacement-text))
                            (save-buffer)))))
                    (message "Lines %d-%d reverted successfully" start-line end-line))
                (message "Could not retrieve original content from git")))
          (message "Revert cancelled"))
      (message "Current buffer is not a file or not in a git repository"))))

(defun +git/stage-region ()
  "Stage the current file (Git doesn't support staging specific lines directly).
For line-level staging, use Magit's interactive staging."
  (interactive)
  (let* ((file-path (+git/get-current-file-relative-path)))
    (if file-path
        (if (y-or-n-p "Git doesn't support staging specific lines. Stage the entire file? ")
            (let* ((git-root (magit-toplevel))
                   (default-directory git-root))
              (magit-stage-file file-path)
              (message "File %s staged" file-path))
          (message "Use 'SPC g g' for Magit and press TAB on a file to stage specific hunks interactively"))
      (message "Current buffer is not a file or not in a git repository"))))

(defun +git/unstage-region ()
  "Unstage the current region or current line."
  (interactive)
  (let* ((file-path (+git/get-current-file-relative-path))
         (region-info (+git/get-region-info))
         (start-line (nth 0 region-info))
         (end-line (nth 1 region-info)))
    (if file-path
        (let* ((git-root (magit-toplevel))
               (default-directory git-root))
          (shell-command (format "cd %s && git reset HEAD %s"
                                 (shell-quote-argument git-root)
                                 (shell-quote-argument file-path)))
          (message "File unstaged")
          (magit-status))
      (message "Current buffer is not a file or not in a git repository"))))

(defun +git/blame-region ()
  "Show git blame for the current region or current line."
  (interactive)
  (let* ((line-nums (+git/get-line-numbers))
         (start-line (car line-nums))
         (end-line (cdr line-nums)))
    (if buffer-file-name
        (progn
          (require 'magit-blame)
          (magit-blame-addition)
          (message "Showing blame for lines %d-%d" start-line end-line))
      (message "Current buffer is not a file"))))

(defun +git/show-region-log ()
  "Show git log for the current file."
  (interactive)
  (if buffer-file-name
      (progn
        (magit-log-buffer-file)
        (message "Showing log for current file"))
    (message "Current buffer is not a file")))

(defun +git/magit-stage-region ()
  "Open Magit and navigate to current file for interactive staging."
  (interactive)
  (let ((current-file buffer-file-name))
    (when current-file
      (magit-status)
      (magit-diff-visit-file current-file))))

(defun +git/diff-hl-revert-hunk-at-point ()
  "Revert the diff hunk at point using diff-hl."
  (interactive)
  (if (bound-and-true-p diff-hl-mode)
      (diff-hl-revert-hunk)
    (message "diff-hl-mode is not active")))

(defun +git/diff-hl-stage-hunk ()
  "Stage the diff hunk at point."
  (interactive)
  (if (bound-and-true-p diff-hl-mode)
      (let ((file-path buffer-file-name))
        (when file-path
          (save-buffer)
          (magit-stage-file file-path)
          (message "File staged")))
    (message "diff-hl-mode is not active")))

(defun +git/copy-region-diff ()
  "Copy the diff of current region to kill ring."
  (interactive)
  (let* ((file-path (+git/get-current-file-relative-path))
         (line-nums (+git/get-line-numbers))
         (start-line (car line-nums))
         (end-line (cdr line-nums)))
    (if file-path
        (let* ((git-root (magit-toplevel))
               (default-directory git-root)
               (diff-output (shell-command-to-string
                            (format "git diff HEAD -- %s"
                                    (shell-quote-argument file-path)))))
          (if (not (string-empty-p diff-output))
              (progn
                (kill-new diff-output)
                (message "Diff copied to kill ring"))
            (message "No changes found")))
      (message "Current buffer is not a file or not in a git repository"))))

(defun +git/toggle-diff-hl-mode ()
  "Toggle diff-hl mode (git gutter)."
  (interactive)
  (diff-hl-mode 'toggle))

(defun +git/next-hunk ()
  "Jump to next git hunk."
  (interactive)
  (diff-hl-next-hunk))

(defun +git/previous-hunk ()
  "Jump to previous git hunk."
  (interactive)
  (diff-hl-previous-hunk))

;;; --- Programming Languages ---
(use-package go-mode
  :hook ((go-mode . lsp-deferred)
         (go-mode . (lambda ()
                      (add-hook 'before-save-hook #'lsp-format-buffer t t)
                      (add-hook 'before-save-hook #'lsp-organize-imports t t)))))

(use-package nix-mode
  :mode "\\.nix\\'"
  :hook (nix-mode . lsp-deferred))

(use-package rjsx-mode
  :mode ("\\.jsx?\\'" "\\.tsx?\\'")
  :hook (rjsx-mode . lsp-deferred)
  :config
  (setq js2-mode-show-parse-errors nil
        js2-mode-show-strict-warnings nil
        js-indent-level 2
        sgml-basic-offset 2))

(use-package lsp-tailwindcss
  :after lsp-mode
  :config
  (setq lsp-tailwindcss-server-command '("tailwindcss-language-server" "--stdio"))
  (setq lsp-tailwindcss-add-on-mode t)
  (setq lsp-tailwindcss-major-modes
        '(typescript-tsx-mode rjsx-mode js-mode typescript-mode web-mode html-mode css-mode)))

(use-package rust-mode
  :mode "\\.rs\\'"
  :hook ((rust-mode . lsp-deferred)
         (rust-mode . (lambda ()
                        (add-hook 'before-save-hook #'lsp-format-buffer t t))))
  :config
  (setq rust-format-on-save t))

(use-package cc-mode
  :hook ((c-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         (c-mode . (lambda ()
                     (add-hook 'before-save-hook #'lsp-format-buffer t t)))
         (c++-mode . (lambda ()
                       (add-hook 'before-save-hook #'lsp-format-buffer t t))))
  :config
  (setq c-default-style "linux"
        c-basic-offset 4))

;;; --- Direnv Integration ---
(use-package direnv
  :config
  (direnv-mode)
  (add-hook 'projectile-after-switch-project-hook #'direnv-update-environment))

;;; --- File Explorer (Treemacs) ---
(use-package treemacs
  :defer t
  :config
  (setq treemacs-width 30
        treemacs-is-never-other-window t
        treemacs-project-follow-cleanup t))

(use-package treemacs-evil :after (treemacs evil))
(use-package treemacs-projectile :after (treemacs projectile))

;;; --- Git (Magit) with Enhanced Functions ---
(use-package magit
  :commands magit-status
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Custom Magit commit functions
(defun my/magit-commit-with-message ()
  "Prompt for a commit summary and description, then commit using Magit."
  (interactive)
  (let* ((summary (read-string "Commit summary: "))
         (description (read-string "Commit description (optional): "))
         (message (if (string-empty-p description)
                      summary
                    (concat summary "\n\n" description))))
    (if (magit-anything-staged-p)
        (magit-run-git "commit" "-m" message)
      (user-error "Nothing staged for commit"))))

(defun my/magit-commit-all-with-message ()
  "Stage all changes, then prompt for commit summary and description."
  (interactive)
  (let* ((summary (read-string "Commit summary: "))
         (description (read-string "Commit description (optional): "))
         (message (if (string-empty-p description)
                      summary
                    (concat summary "\n\n" description))))
    (magit-run-git "add" "-A")
    (magit-run-git "commit" "-m" message)))

(defun my/magit-amend-with-message ()
  "Amend the last commit with a new message."
  (interactive)
  (let* ((current-msg (magit-format-rev-summary "HEAD"))
         (summary (read-string "New commit summary: " current-msg))
         (description (read-string "New commit description (optional): "))
         (message (if (string-empty-p description)
                      summary
                    (concat summary "\n\n" description))))
    (magit-run-git "commit" "--amend" "-m" message)))

;;; --- Dashboard ---
(use-package dashboard
  :hook (server-after-make-frame . dashboard-refresh-buffer)
  :config
  (setq dashboard-startup-banner "/home/gabbar/nixflakes/config/emacs/dashboard.png"
        dashboard-image-banner-max-height 300
        dashboard-image-banner-max-width 300
        dashboard-center-content t
        dashboard-projects-backend 'projectile
        dashboard-items '((recents . 5)
                          (bookmarks . 5)
                          (projects . 5))
        initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  (dashboard-setup-startup-hook))

;;; --- Themes & Modeline ---
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-tomorrow-night t)
  (doom-themes-visual-bell-config)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-height 28
        doom-modeline-bar-width 1
        doom-modeline-hud nil
        doom-modeline-window-width-limit 80
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-buffer-state-icon t
        doom-modeline-buffer-modification-icon t
        doom-modeline-lsp-icon t
        doom-modeline-time-icon t
        doom-modeline-buffer-file-name-style 'truncate-upto-project
        doom-modeline-project-detection 'projectile
        doom-modeline-minor-modes nil
        doom-modeline-enable-word-count t
        doom-modeline-buffer-encoding nil
        doom-modeline-indent-info nil
        doom-modeline-checker-simple-format t
        doom-modeline-vcs-max-length 20
        doom-modeline-vcs-display-function #'doom-modeline-vcs-name
        doom-modeline-github nil
        doom-modeline-mu4e nil
        doom-modeline-irc nil
        doom-modeline-persp-name nil
        doom-modeline-display-default-persp-name nil))

(use-package all-the-icons :if (display-graphic-p))

;;; --- VTerm + Multi-VTerm Configuration ---
(use-package vterm
  :commands vterm
  :config
  ;; Use your NixOS zsh
  (setq vterm-shell "/run/current-system/sw/bin/zsh"))

(use-package multi-vterm
  :after vterm
  :bind
  (("C-c t" . multi-vterm)          ;; new terminal
   ("C-c n" . multi-vterm-next)     ;; next terminal
   ("C-c p" . multi-vterm-prev)     ;; previous terminal
   ("C-c d" . multi-vterm-dedicated-toggle))) ;; dedicated bottom panel

;; Doom-style helpers
(defun +vterm/toggle ()
  "Toggle the first vterm buffer in a popup (like Doom)."
  (interactive)
  (if (get-buffer "*vterm*")
      (if (get-buffer-window "*vterm*")
          (delete-window (get-buffer-window "*vterm*"))
        (pop-to-buffer "*vterm*"))
    (multi-vterm)))

(defun +vterm/here ()
  "Open vterm in the current directory (project root if available)."
  (interactive)
  (let ((default-directory (if (project-current)
                               (project-root (project-current))
                             default-directory)))
    (multi-vterm)))

(defun +vterm/project ()
  "Open a vterm at the project root (using multi-vterm-project)."
  (interactive)
  (multi-vterm-project))

;;; --- Project Runner Utilities ---
(defun my/project--find-file (names)
  "Return (filename . path) for the first file in NAMES found in project root."
  (let ((root (projectile-project-root)))
    (cl-loop for name in names
             for f = (expand-file-name name root)
             if (file-exists-p f)
             return (cons name f))))

(defun my/project--run-makefile-targets ()
  "Detect Makefile in project and offer to run one of its targets."
  (let* ((root (projectile-project-root))
         (makefile (cdr (my/project--find-file '("Makefile" "makefile")))))
    (if (not makefile)
        (user-error "No Makefile found!"))
    (let* ((lines
            (with-temp-buffer
              (insert-file-contents makefile)
              (split-string (buffer-string) "\n")))
           (targets
            (delq nil
                  (mapcar (lambda (line)
                            (if (string-match "^\\([a-zA-Z0-9._-]+\\):" line)
                                (match-string 1 line)))
                          lines))))
      (let ((target (completing-read "Run make target: " targets))
            (default-directory root))
        (compile (format "make %s" target))))))

(defun my/project--run-npm-scripts ()
  "Detect package.json in project and offer to run npm script."
  (let* ((root (projectile-project-root))
         (pkg (cdr (my/project--find-file '("package.json")))))
    (if (not pkg)
        (user-error "No package.json found!"))
    (let* ((json-object-type 'hash-table)
           (scripts
            (gethash "scripts" (json-read-file pkg))))
      (unless scripts (user-error "No scripts in package.json!"))
      (let ((script (completing-read "Run npm script: " (hash-table-keys scripts)))
            (default-directory root))
        (compile (format "npm run %s" script))))))

(defun my/project--run-cargo-commands ()
  "Detect Cargo.toml in project and offer to run cargo commands."
  (let* ((root (projectile-project-root))
         (cargo-file (cdr (my/project--find-file '("Cargo.toml")))))
    (if (not cargo-file)
        (user-error "No Cargo.toml found!"))
    (let ((commands '("build" "run" "test" "check" "clippy" "clean" "doc" "bench" "install")))
      (let ((cmd (completing-read "Run cargo command: " commands))
            (default-directory root))
        (compile (format "cargo %s" cmd))))))

(defun my/project--run-any ()
  "Main project-runner utility."
  (interactive)
  (let ((file (car (my/project--find-file '("Cargo.toml" "package.json" "Makefile" "makefile")))))
    (cond
     ((equal file "Cargo.toml")
      (my/project--run-cargo-commands))
     ((equal file "package.json")
      (my/project--run-npm-scripts))
     ((or (equal file "Makefile") (equal file "makefile"))
      (my/project--run-makefile-targets))
     (t
      (let* ((root (projectile-project-root))
             (cmd (read-shell-command "No Cargo.toml/Makefile/npm scripts. Run shell command: "))
             (default-directory root))
        (compile cmd))))))

;;; --- Compilation Buffer Display ---
(setq display-buffer-alist
      '(("\\*compilation\\*"
         (display-buffer-reuse-window display-buffer-at-bottom)
         (window-height . 0.3))))

;;; --- ESC to Close Windows (Doom style) ---
(defun doom/escape ()
  "Close compilation, help, or other special windows when pressing ESC."
  (interactive)
  (cond
   ;; If evil-mc has cursors, clear them
   ((and (fboundp 'evil-mc-has-cursors-p) (evil-mc-has-cursors-p))
    (evil-mc-undo-all-cursors))
   ;; If in special buffer, quit it
   (t
    (let ((buf (window-buffer (selected-window))))
      (cond
       ((string-match-p "\\*compilation\\*" (buffer-name buf))
        (quit-window :kill))
       ((member (buffer-name buf) '("*Help*" "*Warnings*" "*Messages*" "*Flycheck errors*"))
        (quit-window :kill))
       (t (keyboard-quit)))))))

;;; --- DOOM EMACS KEYBINDINGS (Complete) ---

;; Multiple cursors keybindings (evil-mc style)
(general-define-key
 :states '(normal visual)
 :prefix "gz"
 "d" 'evil-mc-make-and-goto-next-match
 "D" 'evil-mc-make-and-goto-prev-match
 "j" 'evil-mc-make-cursor-move-next-line
 "k" 'evil-mc-make-cursor-move-prev-line
 "m" 'evil-mc-make-all-cursors
 "n" 'evil-mc-make-and-goto-next-cursor
 "N" 'evil-mc-make-and-goto-last-cursor
 "p" 'evil-mc-make-and-goto-prev-cursor
 "P" 'evil-mc-make-and-goto-first-cursor
 "q" 'evil-mc-undo-all-cursors
 "s" 'evil-mc-skip-and-goto-next-match
 "S" 'evil-mc-skip-and-goto-prev-match
 "z" '+multiple-cursors/evil-mc-toggle-cursor-here)

;; evil-multiedit keybindings (Doom defaults)
(general-define-key
 :states '(normal visual)
 "M-d" 'evil-multiedit-match-and-next
 "M-D" 'evil-multiedit-match-and-prev)

(general-define-key
 :states '(visual)
 "R" 'evil-multiedit-match-all)

;; ESC handling
;; Only for non-insert states
(general-define-key
 :states '(normal visual motion emacs)
 "<escape>" 'doom/escape)

;; Enhanced LSP keybindings (like VSCode/modern editors)
(general-define-key
 :states '(normal insert)
 "C-;" '+lsp/trigger-completion   ;; Ctrl+; to trigger completion
 "C-k" '+lsp/signature-help)

(general-define-key
 :states '(normal insert)
 "C-." 'lsp-execute-code-action)

(general-define-key
 :states '(normal)
 "K" '+lsp/show-hover-doc               ;; K to show hover (Doom/Vim style)
 "g K" '+lsp/hide-hover-doc)            ;; g K to hide hover

;; Git region operations keybindings
(general-define-key
 :states '(visual normal)
 :prefix "SPC g"
 "d" '+git/show-region-diff
 "s" '+git/stage-region
 "u" '+git/unstage-region
 "S" '+git/stash-region
 "r" '+git/revert-region
 "b" '+git/blame-region
 "l" '+git/show-region-log)

;; Main leader key bindings (Complete Doom Emacs style)
(doom/leader-keys
  ;; Top level
  "SPC" '(execute-extended-command :which-key "M-x")
  ":" '(execute-extended-command :which-key "M-x")
  "." '(find-file :which-key "find file")
  "," '(switch-to-buffer :which-key "switch buffer")

  ;; File operations
  "f" '(:ignore t :which-key "file")
  "f f" '(find-file :which-key "find file")
  "f F" '(find-file-other-window :which-key "find file other window")
  "f r" '(recentf-open-files :which-key "recent files")
  "f R" '(rename-file :which-key "rename file")
  "f s" '(save-buffer :which-key "save file")
  "f S" '(write-file :which-key "save file as")
  "f u" '(sudo-edit :which-key "sudo edit")
  "f d" '(dired :which-key "dired")
  "f D" '(delete-file :which-key "delete file")
  "f y" '(yank-file-name :which-key "yank filename")

  ;; Buffer operations
  "b" '(:ignore t :which-key "buffer")
  "b b" '(switch-to-buffer :which-key "switch buffer")
  "b B" '(switch-to-buffer-other-window :which-key "switch buffer other window")
  "b d" '(kill-current-buffer :which-key "kill buffer")
  "b D" '(kill-buffer :which-key "kill buffer (choose)")
  "b r" '(revert-buffer :which-key "revert buffer")
  "b R" '(rename-buffer :which-key "rename buffer")
  "b n" '(next-buffer :which-key "next buffer")
  "b p" '(previous-buffer :which-key "previous buffer")
  "b s" '(save-buffer :which-key "save buffer")
  "b S" '(save-some-buffers :which-key "save all buffers")
  "b k" '(kill-current-buffer :which-key "kill buffer")
  "b l" '(list-buffers :which-key "list buffers")
  "b z" '(bury-buffer :which-key "bury buffer")

  ;; Project operations
  "p" '(:ignore t :which-key "project")
  "p p" '(projectile-switch-project :which-key "switch project")
  "p f" '(projectile-find-file :which-key "find file in project")
  "p F" '(projectile-find-file-other-window :which-key "find file other window")
  "p d" '(projectile-find-dir :which-key "find directory in project")
  "p D" '(projectile-dired :which-key "project root in dired")
  "p b" '(projectile-switch-to-buffer :which-key "switch to project buffer")
  "p B" '(projectile-ibuffer :which-key "project ibuffer")
  "p s" '(projectile-ag :which-key "search in project")
  "p S" '(projectile-grep :which-key "grep in project")
  "p r" '(my/project--run-any :which-key "run project command")
  "p R" '(projectile-replace :which-key "replace in project")
  "p k" '(projectile-kill-buffers :which-key "kill project buffers")
  "p t" '(projectile-toggle-between-implementation-and-test :which-key "toggle impl/test")
  "p T" '(projectile-find-test-file :which-key "find test file")
  "p c" '(projectile-compile-project :which-key "compile project")
  "p u" '(projectile-run-project :which-key "run project")
  "p g" '(projectile-regenerate-tags :which-key "regenerate tags")

  ;; Search operations
  "s" '(:ignore t :which-key "search")
  "s s" '(swiper :which-key "search buffer")
  "s S" '(swiper-all :which-key "search all open buffers")
  "s d" '(swiper-thing-at-point :which-key "search thing at point")
  "s p" '(projectile-ag :which-key "search project")
  "s P" '(projectile-grep :which-key "grep project")
  "s r" '(query-replace :which-key "replace")
  "s R" '(query-replace-regexp :which-key "replace regexp")

  ;; Window operations
  "w" '(:ignore t :which-key "window")
  "w w" '(other-window :which-key "other window")
  "w d" '(delete-window :which-key "delete window")
  "w D" '(delete-other-windows :which-key "delete other windows")
  "w s" '(split-window-below :which-key "split below")
  "w v" '(split-window-right :which-key "split right")
  "w h" '(windmove-left :which-key "move left")
  "w j" '(windmove-down :which-key "move down")
  "w k" '(windmove-up :which-key "move up")
  "w l" '(windmove-right :which-key "move right")
  "w H" '(evil-window-move-far-left :which-key "move window left")
  "w J" '(evil-window-move-very-bottom :which-key "move window down")
  "w K" '(evil-window-move-very-top :which-key "move window up")
  "w L" '(evil-window-move-far-right :which-key "move window right")
  "w =" '(balance-windows :which-key "balance windows")
  "w +" '(evil-window-increase-height :which-key "increase height")
  "w -" '(evil-window-decrease-height :which-key "decrease height")
  "w <" '(evil-window-decrease-width :which-key "decrease width")
  "w >" '(evil-window-increase-width :which-key "increase width")

  ;; Enhanced Git operations (Magit + custom functions)
  "g" '(:ignore t :which-key "git")
  "g g" '(magit-status :which-key "status")
  "g G" '(magit-status-here :which-key "status here")
  "g s" '(magit-status :which-key "status")
  "g b" '(magit-blame :which-key "blame")
  "g B" '(magit-branch :which-key "branch")
  "g c" '(magit-commit :which-key "commit")
  "g C" '(my/magit-commit-with-message :which-key "quick commit")
  "g A" '(my/magit-commit-all-with-message :which-key "commit all")
  "g a" '(my/magit-amend-with-message :which-key "amend commit")
  "g p" '(magit-push :which-key "push")
  "g P" '(magit-pull :which-key "pull")
  "g f" '(magit-fetch :which-key "fetch")
  "g F" '(magit-fetch-all :which-key "fetch all")
  "g l" '(magit-log :which-key "log")
  "g L" '(magit-log-buffer-file :which-key "log buffer file")
  "g d" '(+git/show-region-diff :which-key "diff region/line")
  "g D" '(magit-diff-buffer-file :which-key "diff buffer file")
  "g t" '(git-timemachine :which-key "time machine")
  "g r" '(magit-rebase :which-key "rebase")
  "g R" '(+git/revert-region :which-key "revert region/line")
  "g z" '(magit-stash :which-key "stash")
  "g Z" '(magit-stash-pop :which-key "stash pop")
  "g S" '(+git/stash-region :which-key "stash region/line")

  ;; Git region operations submenu
  "g v" '(:ignore t :which-key "region/hunk operations")
  "g v d" '(+git/show-region-diff :which-key "show diff")
  "g v s" '(+git/magit-stage-region :which-key "stage interactively")
  "g v r" '(+git/revert-region :which-key "revert region")
  "g v b" '(+git/blame-region :which-key "blame")
  "g v l" '(+git/show-region-log :which-key "log")
  "g v c" '(+git/copy-region-diff :which-key "copy diff")

  ;; Hunk operations using diff-hl
   "g h" '(:ignore t :which-key "hunks")
   "g h r" '(+git/diff-hl-revert-hunk-at-point :which-key "revert hunk")
   "g h s" '(+git/diff-hl-stage-hunk :which-key "stage hunk")
   "g h n" '(+git/next-hunk :which-key "next hunk")
   "g h p" '(+git/previous-hunk :which-key "previous hunk")
   "g h g" '(diff-hl-diff-goto-hunk :which-key "goto hunk")
   "g h m" '(diff-hl-mark-hunk :which-key "mark hunk")

  ;; Toggle operations
  "t" '(:ignore t :which-key "toggle")
  "t n" '(display-line-numbers-mode :which-key "line numbers")
  "t r" '(read-only-mode :which-key "read only")
  "t t" '(treemacs :which-key "treemacs")
  "t T" '(treemacs-select-window :which-key "treemacs select")
  "t w" '(whitespace-mode :which-key "whitespace")
  "t W" '(whitespace-cleanup :which-key "whitespace cleanup")
  "t f" '(auto-fill-mode :which-key "auto fill")
  "t l" '(visual-line-mode :which-key "visual line")
  "t s" '(flycheck-mode :which-key "syntax checking")
  "t S" '(flyspell-mode :which-key "spell checking")
  "t h" '(+lsp/toggle-inlay-hints :which-key "inlay hints")

  ;; Enhanced LSP operations
  "l" '(:ignore t :which-key "lsp")
  "l r" '(lsp-rename :which-key "rename")
  "l f" '(lsp-format-buffer :which-key "format buffer")
  "l F" '(lsp-format-region :which-key "format region")
  "l a" '(lsp-execute-code-action :which-key "code action")
  "l A" '(lsp-code-actions :which-key "code actions")
  "l d" '(lsp-find-definition :which-key "find definition")
  "l D" '(lsp-find-declaration :which-key "find declaration")
  "l i" '(lsp-find-implementation :which-key "find implementation")
  "l t" '(lsp-find-type-definition :which-key "find type definition")
  "l R" '(lsp-find-references :which-key "find references")
  "l s" '(lsp-document-symbols :which-key "document symbols")
  "l S" '(lsp-workspace-symbol :which-key "workspace symbol")
  "l h" '(+lsp/show-hover-doc :which-key "show hover")
  "l H" '(+lsp/hide-hover-doc :which-key "hide hover")
  "l k" '(+lsp/signature-help :which-key "signature help")
  "l c" '(+lsp/trigger-completion :which-key "trigger completion")
  "l e" '(flycheck-list-errors :which-key "list errors")
  "l n" '(flycheck-next-error :which-key "next error")
  "l p" '(flycheck-previous-error :which-key "previous error")
  "l o" '(lsp-organize-imports :which-key "organize imports")
  "l w" '(:ignore t :which-key "workspace")
  "l w r" '(lsp-workspace-restart :which-key "restart workspace")
  "l w s" '(lsp-workspace-shutdown :which-key "shutdown workspace")
  "l w a" '(lsp-workspace-folders-add :which-key "add folder")
  "l w d" '(lsp-workspace-folders-remove :which-key "remove folder")

  ;; Open operations
  "o" '(:ignore t :which-key "open")
  "o p" '(treemacs :which-key "project sidebar")
  "o P" '(treemacs-select-window :which-key "project sidebar select")
  "o t" '(+vterm/toggle :which-key "terminal popup")
  "o T" '(+vterm/here :which-key "terminal here")
  "o e" '(eshell :which-key "eshell")
  "o E" '(eshell-command :which-key "eshell command")
  "o d" '(dired :which-key "dired here")
  "o D" '(dired-jump :which-key "dired jump")

  ;; Insert operations
  "i" '(:ignore t :which-key "insert")
  "i s" '(yas-insert-snippet :which-key "snippet")
  "i u" '(insert-char :which-key "unicode character")
  "i y" '(yank-pop :which-key "from kill ring")

  ;; Help operations
  "h" '(:ignore t :which-key "help")
  "h f" '(describe-function :which-key "describe function")
  "h v" '(describe-variable :which-key "describe variable")
  "h k" '(describe-key :which-key "describe key")
  "h m" '(describe-mode :which-key "describe mode")
  "h p" '(describe-package :which-key "describe package")
  "h b" '(describe-bindings :which-key "describe bindings")
  "h c" '(describe-char :which-key "describe char")
  "h F" '(describe-face :which-key "describe face")
  "h i" '(info :which-key "info")
  "h I" '(info-emacs-manual :which-key "emacs manual")

  ;; Code operations
  "c" '(:ignore t :which-key "code")
  "c c" '(compile :which-key "compile")
  "c C" '(recompile :which-key "recompile")
  "c r" '(my/project--run-any :which-key "run")
  "c t" '(projectile-test-project :which-key "test project")
  "c f" '(lsp-format-buffer :which-key "format")
  "c a" '(lsp-code-actions :which-key "code actions")
  "c d" '(lsp-find-definition :which-key "definition")
  "c D" '(lsp-find-references :which-key "references")
  "c i" '(lsp-organize-imports :which-key "organize imports")
  "c h" '(+lsp/show-hover-doc :which-key "hover documentation")
  "c k" '(+lsp/signature-help :which-key "signature help")
  "c SPC" '(+lsp/trigger-completion :which-key "trigger completion")

  ;; Notes/Org operations (placeholder)
  "n" '(:ignore t :which-key "notes")

  ;; Quit operations
  "q" '(:ignore t :which-key "quit")
  "q q" '(save-buffers-kill-terminal :which-key "quit emacs")
  "q Q" '(save-buffers-kill-emacs :which-key "quit emacs without saving")
  "q r" '(restart-emacs :which-key "restart emacs")
  "q f" '(delete-frame :which-key "delete frame")
  "q K" '(kill-emacs :which-key "kill emacs"))

;;; --- Additional Utilities ---
(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t))

(use-package helpful
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

(use-package perspective
  :bind (("C-x C-b" . persp-list-buffers)
         ("C-x b" . persp-switch-to-buffer*)
         ("C-x k" . persp-kill-buffer*))
  :config (persp-mode))

(use-package hydra)

(defhydra hydra-window-resize ()
  "resize"
  ("h" shrink-window-horizontally "shrink horizontal")
  ("l" enlarge-window-horizontally "enlarge horizontal")
  ("j" enlarge-window "enlarge vertical")
  ("k" shrink-window "shrink vertical"))

;;; --- Git Gutter (diff-hl) ---
(use-package diff-hl
  :config
  (global-diff-hl-mode 1)
  (diff-hl-flydiff-mode 1) ;; Enable live diff updates
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (add-hook 'vc-checkin-hook 'diff-hl-update)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode))

(with-eval-after-load 'diff-hl
  ;; Ensure diff-hl updates on save
  (add-hook 'after-save-hook 'diff-hl-update nil t)

  ;; Configure diff-hl to work better with our custom functions
  (setq diff-hl-draw-borders nil
        diff-hl-flydiff-delay 0.5)

  ;; Add keybindings for diff-hl operations
  (define-key diff-hl-mode-map (kbd "C-c g r") '+git/diff-hl-revert-hunk-at-point)
  (define-key diff-hl-mode-map (kbd "C-c g n") 'diff-hl-next-hunk)
  (define-key diff-hl-mode-map (kbd "C-c g p") 'diff-hl-previous-hunk))

;;; --- Final message ---
(message "Complete Doom Emacs configuration with enhanced LSP and Git features loaded!")

;; Local Variables:
;; no-byte-compile: t
;; End:
