;; -*- lexical-binding: t; -*-
;; Nix-managed Doom-like Emacs configuration - final version with all fixes

;; Disable backup, autosave, lockfiles
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil
      auto-save-list-file-prefix nil
      version-control nil
      kept-new-versions 0 kept-old-versions 0)

(setq inhibit-startup-message t
      initial-scratch-message nil
      ring-bell-function 'ignore
      custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

;; Font and UI
(set-face-attribute 'default nil :family "JetBrainsMono Nerd Font Mono" :height 120)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode 1)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(save-place-mode 1)
(global-auto-revert-mode 1)

;; Window splitting preference: horizontal by default
(setq split-height-threshold nil
      split-width-threshold 120)
(setq split-window-preferred-function
      (lambda (window)
        (or (and (window-splittable-p window t)
                 (split-window window nil t))
            (and (window-splittable-p window)
                 (split-window window)))))

;;; Garbage Collection & Native Compilation
(setq gc-cons-threshold (* 100 1024 1024))
(add-hook 'emacs-startup-hook (lambda () (setq gc-cons-threshold (* 4 1024 1024))))
(when (fboundp 'native-compile-async)
  (setq native-comp-jit-compilation t
        native-comp-speed 3
        native-comp-warning-on-missing-native t))

;;; use-package set to nix because nix pkg manager manages them
(setq use-package-always-ensure nil)

;;; Evil & General
(use-package evil :init (setq evil-want-integration t evil-want-keybinding nil
                                   evil-want-C-u-scroll t evil-want-C-i-jump nil
                                   evil-respect-visual-line-mode t evil-undo-system 'undo-tree)
  :config (evil-mode 1))
(use-package evil-collection :after evil :config (evil-collection-init))
(use-package general :config
  (general-create-definer doom/leader-keys :keymaps '(normal insert visual emacs)
    :prefix "SPC" :global-prefix "C-SPC")
  (general-create-definer doom/local-leader-keys :keymaps '(normal insert visual emacs)
    :prefix "SPC m" :global-prefix "C-SPC m"))

;;; which-key
(use-package which-key :init
  (setq which-key-separator " " which-key-prefix-prefix "+"
        which-key-allow-imprecise-window-fit nil which-key-popup-type 'side-window
        which-key-side-window-max-height 0.3)
  :config (which-key-mode) (setq which-key-idle-delay 0.3))

;;; Ivy & Completion
(use-package ivy :bind (("C-s" . swiper)) :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t ivy-wrap t ivy-count-format "(%d/%d) "
        enable-recursive-minibuffers t
        ivy-re-builders-alist '((ivy-bibtex . ivy--regex-ignore-order) (t . ivy--regex-plus))))
(use-package counsel :after ivy :bind (("M-x" . counsel-M-x)
                                       ("C-x b" . counsel-ibuffer)
                                       ("C-x C-f" . counsel-find-file)
                                       :map minibuffer-local-map ("C-r" . counsel-minibuffer-history))
  :config (setq ivy-initial-inputs-alist nil))
(use-package swiper)
(use-package ivy-rich :after ivy :config (ivy-rich-mode 1))

;; Keep undo-tree in memory only, no on-disk files
(with-eval-after-load 'undo-tree
  (setq undo-tree-auto-save-history nil))



;;; Company & UI
(use-package company :config
  (global-company-mode)
  (setq company-idle-delay 0.3
        company-minimum-prefix-length 2
        company-show-numbers t
        company-tooltip-align-annotations t
        company-tooltip-flip-when-above t
        ;; Remove snippet backend to avoid placeholder expansion
        company-backends (mapcar (lambda (b)
                                   (if (and (listp b) (memq 'company-yasnippet b))
                                       (remove 'company-yasnippet b)
                                     b))
                                 company-backends)))
(use-package company-box :after company :hook (company-mode . company-box-mode))

;;; Projectile & Counsel-Projectile
(use-package projectile :config
  (projectile-mode 1)
  (setq projectile-completion-system 'ivy
        projectile-switch-project-action #'projectile-dired))
(use-package counsel-projectile :after (counsel projectile) :config (counsel-projectile-mode))

;;; Flycheck
(use-package flycheck :config
  (global-flycheck-mode)
  (setq flycheck-display-errors-delay 0.1
        flycheck-emacs-lisp-load-path 'inherit))

;;; LSP Mode & UI
(use-package lsp-mode :init
  (setq lsp-keymap-prefix "C-c l"
        lsp-enable-snippet nil
        lsp-gopls-use-placeholders nil
        lsp-completion-provider :capf)
  :hook ((go-mode . lsp-deferred)
         (nix-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-auto-guess-root t
        lsp-prefer-flymake nil
        lsp-file-watch-threshold 2000
        lsp-eldoc-render-all t
        lsp-idle-delay 0.6
        lsp-headerline-breadcrumb-enable nil
        lsp-restart 'auto-restart
        lsp-enable-symbol-highlighting t
        lsp-enable-on-type-formatting nil
        lsp-signature-auto-activate nil
        lsp-signature-render-documentation nil
        lsp-modeline-code-actions-enable t
        lsp-modeline-diagnostics-enable t
        lsp-format-buffer-on-save t
        lsp-log-io nil))
(use-package lsp-ui :after lsp-mode :commands lsp-ui-mode
  :config
  (setq lsp-ui-peek-always-show t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-ignore-duplicate t
        lsp-ui-doc-enable nil
        lsp-ui-doc-position 'bottom
        lsp-ui-doc-delay 2
        lsp-ui-peek-fontify 'on-demand
        lsp-ui-sideline-show-code-actions t))
(use-package lsp-ivy :after (lsp-mode ivy) :commands lsp-ivy-workspace-symbol)

;;; Go & Nix Modes
(use-package go-mode :hook ((go-mode . lsp-deferred)
                             (go-mode . (lambda ()
                                          (add-hook 'before-save-hook #'lsp-format-buffer t t)
                                          (add-hook 'before-save-hook #'lsp-organize-imports t t)))))
(use-package nix-mode :mode "\\.nix\\'" :hook (nix-mode . lsp-deferred))

;;; Direnv
(use-package direnv :config
  (direnv-mode)
  (add-hook 'projectile-after-switch-project-hook #'direnv-update-environment))

;;; Treemacs & Magit & Dashboard
(use-package treemacs :defer t :config
  (setq treemacs-width 30 treemacs-is-never-other-window t treemacs-project-follow-cleanup t))
(use-package treemacs-evil :after (treemacs evil))
(use-package treemacs-projectile :after (treemacs projectile))
(use-package magit :commands magit-status :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))
(use-package dashboard :hook (server-after-make-frame . dashboard-refresh-buffer)
  :config
  (setq dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-projects-backend 'projectile
        dashboard-items '((recents . 5) (bookmarks . 5) (projects . 5))
        initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  (dashboard-setup-startup-hook))

;;; Themes & Modeline
(use-package doom-themes :config
  (setq doom-themes-enable-bold t doom-themes-enable-italic t)
  (load-theme 'doom-tomorrow-night t)
  (doom-themes-visual-bell-config)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))
(use-package doom-modeline :hook (after-init . doom-modeline-mode)
  :config (setq doom-modeline-height 35 doom-modeline-bar-width 3
                doom-modeline-project-detection 'projectile
                doom-modeline-buffer-file-name-style 'truncate-upto-project
                doom-modeline-lsp t))
(use-package all-the-icons :if (display-graphic-p))

;;; VTerm
(use-package vterm :commands vterm :config
  (setq vterm-shell "/run/current-system/sw/bin/zsh")
  (doom/leader-keys
    "oT" '(vterm :which-key "vterm new terminal")
    "ot" '(vterm-other-window :which-key "terminal in new window")))
(defun vterm-other-window () (interactive)
  (split-window-right) (other-window 1) (vterm))

;;; Compilation Buffer Horizontal Split
(defun my/compilation-buffer-p (buffer-name _action)
  "Detect compilation buffers."
  (with-current-buffer buffer-name
    (derived-mode-p 'compilation-mode)))
(add-to-list 'display-buffer-alist
             '(my/compilation-buffer-p
               (display-buffer-at-bottom)
               (window-height . 0.25)
               (dedicated . t)
               (preserve-size . (nil . t))))
(defun my/go-to-compilation ()
  "Switch to *compilation* buffer."
  (interactive)
  (if-let ((buf (get-buffer "*compilation*")))
      (switch-to-buffer-other-window buf)
    (message "No compilation buffer")))
(define-key doom/leader-keys "cg" #'my/go-to-compilation)
(define-key doom/leader-keys "cc" #'compile)
(define-key doom/leader-keys "cr" #'recompile)

;;; Smartparens, Helpful, Perspective, Hydra
(use-package smartparens :config (require 'smartparens-config) (smartparens-global-mode t))
(use-package helpful :bind ([remap describe-function] . helpful-callable)
                          ([remap describe-variable] . helpful-variable)
                          ([remap describe-key] . helpful-key))
(use-package perspective :bind (("C-x C-b" . persp-list-buffers)
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

(message "Nix Doom Emacs (final) loaded!")

;; Local Variables:
;; no-byte-compile: t
;; End:
