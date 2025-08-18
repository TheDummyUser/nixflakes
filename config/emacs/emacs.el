;; -*- lexical-binding: t; -*-

;; this turns off use package downloding stuff so we can use nix pkgs we installed
(setq use-package-always-ensure nil)

;; default theme settings and so
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(electric-pair-mode 1)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
;; Stop creating backup~ files
(setq make-backup-files nil)
;; Stop creating #autosave# files
(setq auto-save-default nil)
;; Stop lockfiles like .#filename
(setq create-lockfiles nil)



;; font faminly
;; Set font reliably for GUI and daemon
(setq default-frame-alist
      '((font . "JetBrainsMono Nerd Font Mono-13")))
(add-to-list 'initial-frame-alist '(font . "JetBrainsMono Nerd Font Mono-13"))

;; If running as daemon, apply font to new frames too
(when (daemonp)
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (with-selected-frame frame
                (set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono-13")))))

;; (set-frame-parameter nil 'left-fringe-width 0)
;; (set-frame-parameter nil 'right-fringe-width 0)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package which-key
  :init (which-key-mode 1))
(use-package vertico
  :init (vertico-mode 1))
(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))
(use-package consult)
(use-package consult-dir)
(use-package avy
  :bind ("M-s" . avy-goto-char-timer))

(use-package projectile
  :config (projectile-mode +1))
(use-package consult-projectile)



(use-package doom-themes
  :config
  (load-theme 'doom-tomorrow-night t))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

(use-package dashboard
  :init
  ;; Show dashboard at startup
  (setq inhibit-startup-screen t)           ;; disable GNU splash
  (setq initial-buffer-choice (lambda ()    ;; force dashboard as first buffer
                                (get-buffer "*dashboard*")))
  ;; Optional: prefer dashboard when creating a new frame
  (setq initial-scratch-message nil)        ;; empty scratch buffer if it’s ever shown
  :config
  (setq dashboard-startup-banner 'official
        dashboard-center-content t
        dashboard-items '((recents  . 5)
                          (bookmarks . 5)
                          (projects . 5)))
  (dashboard-setup-startup-hook))


(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1))

;; Tell lsp-mode to provide CAPF entries and let corfu display them
(with-eval-after-load 'lsp-mode
  (setq lsp-completion-provider :capf))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  ;; prefer lsp over eglot if both are present
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-auto-guess-root t)
  (setq lsp-completion-provider :none) ;; we'll let corfu handle UI
  :hook ((go-mode . lsp-deferred)
         (nix-mode . lsp-deferred)
         (web-mode . lsp-deferred)
         (typescript-mode . lsp-deferred)
         (tsx-ts-mode . lsp-deferred))  ;; only if using tree-sitter tsx
  )

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :init
  (setq lsp-ui-doc-show-with-cursor t
        lsp-ui-doc-delay 0.2
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-code-actions t))

(use-package flycheck)



;; Always use a bottom-side window for compilation buffer
(setq display-buffer-alist
      '(("\\*compilation\\*"
         (display-buffer-reuse-window display-buffer-at-bottom)
         (window-height . 0.3))))



(use-package go-mode
  :mode ("\\.go\\'" . go-mode))

(use-package nix-mode
  :mode ("\\.nix\\'" . nix-mode))

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.js\\'" . web-mode)
         ("\\.jsx\\'" . web-mode))
  :config
  (setq web-mode-enable-auto-closing t)        ;; enable tag auto-closing
  (setq web-mode-tag-auto-close-style 1))      ;; 1 for </ style, 2 for <div> style


(use-package typescript-mode
  :mode (("\\.ts\\'" . typescript-mode)
         ("\\.tsx\\'" . typescript-mode)))


(use-package envrc
  :init
  (envrc-global-mode))  ;; loads .envrc per-directory automatically
