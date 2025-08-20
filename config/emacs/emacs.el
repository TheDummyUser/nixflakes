;;; init.el --- Nix-based Emacs config -*- lexical-binding: t; -*-

;; --------------------------------
;; Package management
;; --------------------------------
(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure nil) ;; prevent network downloads (Nix provides pkgs)

(setq native-comp-speed 3)

;; GC tuning
(setq gc-cons-threshold (* 64 1024 1024)
      gc-cons-percentage 0.2)
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold (* 8 1024 1024)
                  gc-cons-percentage 0.1)))

;; Faster UI during startup
(setq read-process-output-max (* 3 1024 1024))
(setq idle-update-delay 1.0)

;; --------------------------------
;; UI / Fonts
;; --------------------------------
(setq default-frame-alist '((font . "JetBrainsMono Nerd Font Mono-13")))
(add-to-list 'initial-frame-alist '(font . "JetBrainsMono Nerd Font Mono-13"))
(when (daemonp)
  (add-hook 'after-make-frame-functions
            (lambda (f)
              (with-selected-frame f
                (set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono-13")))))
(set-face-attribute 'font-lock-comment-face nil :slant 'italic)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; turn off bell
(setq visible-bell t)
(setq ring-bell-function 'ignore)

(setq make-backup-files nil
      auto-save-default nil
      auto-save-list-file-prefix nil
      create-lockfiles nil)

;; Theme (lazy-load by deferring until first use of faces)
(use-package doom-themes
  :defer t
  :init
  (add-hook 'after-init-hook (lambda () (load-theme 'doom-one t))))

;; Modeline (after init so it doesn't block startup)
(use-package doom-modeline
  :defer t
  :hook (after-init . doom-modeline-mode)
  :custom (doom-modeline-height 15))

;; --------------------------------
;; Evil + General + Which-key
;; --------------------------------
(use-package evil
  :defer t
  :init (setq evil-want-keybinding nil)
  :hook (after-init . evil-mode))

(use-package evil-collection
  :defer t
  :after evil
  :config (evil-collection-init))

(use-package which-key
  :defer 0.5
  :init
  (which-key-mode 1)
  :custom
  (which-key-idle-delay 0.3)
  (which-key-idle-secondary-delay 0.05)
  (which-key-max-description-length 40)
  (which-key-min-display-lines 10)
  (which-key-side-window-location 'bottom))

(use-package general
  :demand t
  :config
  (general-create-definer my/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  ;; File operations
  (my/leader-keys
    "f"  '(:ignore t :which-key "file")
    "ff" '(find-file :which-key "find file")
    "fs" '(save-buffer :which-key "save file")
    "fr" '(recentf-open-files :which-key "recent files"))

  ;; Buffer management
  (my/leader-keys
    "b"  '(:ignore t :which-key "buffer")
    "bb" '(switch-to-buffer :which-key "switch buffer")
    "bk" (lambda () (interactive) (kill-this-buffer))
    "bn" '(next-buffer :which-key "next buffer")
    "bp" '(previous-buffer :which-key "previous buffer"))

  ;; Project (projectile)
  (my/leader-keys
    "p"  '(:ignore t :which-key "project")
    "pf" '(projectile-find-file :which-key "find project file")
    "pp" '(projectile-switch-project :which-key "switch project")
    "ps" '(projectile-ripgrep :which-key "search in project"))

  ;; Compilation / Running apps
  (my/leader-keys
    "c"  '(:ignore t :which-key "compile/run")
    "cc" '(compile :which-key "compile project")
    "cr" '(recompile :which-key "recompile last")
    "cm" '(projectile-compile-project :which-key "project compile")
    "cx" '(async-shell-command :which-key "run shell command"))

  ;; Git / Magit
  (my/leader-keys
    "g"  '(:ignore t :which-key "git")
    "gs" '(magit-status :which-key "status")
    "gc" '(magit-commit :which-key "commit")
    "gp" '(magit-push-current :which-key "push")
    "gl" '(magit-log :which-key "log"))

  ;; Navigation: xref
  (my/leader-keys
    "j"  '(:ignore t :which-key "jump")
    "jd" '(xref-find-definitions :which-key "go to definition")
    "jr" '(xref-find-references  :which-key "find references")
    "jb" '(xref-pop-marker-stack :which-key "back"))

  ;; Diagnostics: Flymake
  (my/leader-keys
    "e"   '(:ignore t :which-key "errors/diagnostics")
    "en"  '(flymake-goto-next-error :which-key "next error")
    "ep"  '(flymake-goto-prev-error :which-key "prev error")
    "el"  '(flymake-show-buffer-diagnostics :which-key "list buffer errors")
    "eL"  '(flymake-show-project-diagnostics :which-key "list project errors")
    "em"  '(flymake-show-diagnostics-at-point :which-key "error at point"))

  ;; Dired group (added)
  (my/leader-keys
    "d"  '(:ignore t :which-key "dired")
    "dd" '(dired :which-key "open dired here")
    "dj" '(dired-jump :which-key "jump to file in dired")
    "ds" '(dired-rg :which-key "ripgrep in dir")
    "di" '(dired-sidebar-toggle-sidebar :which-key "toggle sidebar")
    "da" '(dired-do-async-shell-command :which-key "async shell on marked")
    "dr" '(dired-rsync :which-key "rsync marked")
    "df" '(dired-filter-mode :which-key "toggle filters")
    "dn" '(dired-narrow :which-key "narrow")))

;; --------------------------------
;; Completion stack (Corfu + Orderless + Yasnippet)
;; --------------------------------
(use-package envrc
  :defer t
  :hook (after-init . envrc-global-mode))

(use-package corfu
  :defer 0.2
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.0)
  (corfu-auto-prefix 1)
  (corfu-preview-current nil)
  (corfu-preselect 'prompt))

(use-package orderless
  :defer t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package yasnippet
  :defer t
  :hook (prog-mode . yas-minor-mode)
  :config (yas-reload-all))

;; --------------------------------
;; LSP + Flycheck
;; --------------------------------
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((go-mode . lsp-deferred)
         (nix-mode . lsp-deferred)
         (web-mode . lsp-deferred)
         (typescript-mode . lsp-deferred))
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  ;; General LSP tuning
  (setq lsp-enable-snippet t
        lsp-enable-symbol-highlighting t
        lsp-headerline-breadcrumb-enable nil
        lsp-idle-delay 0.2
        read-process-output-max (* 3 1024 1024)
        lsp-completion-provider :none)

  ;; Nix-specific: enable flake input auto-evaluation/archiving
  ;; These variables are read by lsp-nix (nil language server)
  (setq lsp-nix-nil-auto-eval-inputs t
        ;; optional but recommended for flakes:
        lsp-nix-nil-flake t
        ;; auto download Nixpkgs input if missing (set to nil if you want strict offline)
        lsp-nix-nil-auto-install t
        ;; control evaluation depth of inputs (t for default behavior or a number)
        ;; lsp-nix-nil-nix-eval-depth 2
        )

  ;; Keep Orderless for LSP completions via Corfu
  (add-hook 'lsp-completion-mode-hook
            (lambda ()
              (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
                    '(orderless)))))


(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode))

(use-package flycheck
  :defer t
  :hook (lsp-mode . flycheck-mode))

;; Optional: CAPE integration
(use-package cape
  :defer t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file))

;; --------------------------------
;; Languages (lazy)
;; --------------------------------
(use-package go-mode
  :mode "\\.go\\'")

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package web-mode
  :mode "\\.html?\\'")

(use-package typescript-mode
  :mode "\\.ts\\'")

;; --------------------------------
;; Other goodies
;; --------------------------------
(use-package magit
  :commands (magit-status magit-log magit-commit)
  :defer t)

(use-package projectile
  :defer t
  :init (projectile-mode 1)
  :custom
  (projectile-indexing-method 'alien)
  (projectile-enable-caching t)
  (projectile-project-search-path '("~/code" "~/work"))
  (projectile-globally-ignored-directories '(".git" ".direnv" "node_modules" "dist" "target"))
  (projectile-generic-command "rg --files --hidden --follow -g !.git -g !.direnv"))

(use-package consult
  :defer t
  :commands (consult-ripgrep consult-buffer consult-recent-file))

(use-package consult-dir
  :defer t
  :after consult
  :commands consult-dir)

(use-package avy
  :defer t
  :commands (avy-goto-char avy-goto-word-1))

(use-package multiple-cursors
  :defer t
  :commands (mc/edit-lines mc/mark-next-like-this mc/mark-previous-like-this))

;; --------------------------------
;; Dired: enhancements and file search
;; --------------------------------
;; Built-in dired settings
(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :hook ((dired-mode . dired-hide-details-mode))
  :custom
  (dired-listing-switches "-alh --group-directories-first")
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always)
  (dired-dwim-target t)
  (delete-by-moving-to-trash t)
  :config
  ;; Open directories in the same buffer (like Ranger)
  (put 'dired-find-alternate-file 'disabled nil)
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
  (define-key dired-mode-map (kbd "^")
    (lambda () (interactive) (find-alternate-file ".."))))

;; Async operations in Dired
(use-package dired-async
  :after dired
  :commands (dired-async-mode)
  :init (add-hook 'dired-mode-hook #'dired-async-mode))

;; Dired filtering and narrowing
(use-package dired-filter
  :after dired
  :commands (dired-filter-mode)
  :hook (dired-mode . dired-filter-mode))

(use-package dired-narrow
  :after dired
  :commands (dired-narrow))

;; Dired rsync
(use-package dired-rsync
  :after dired
  :commands (dired-rsync))

;; Optional: icons in Dired (requires Nerd Font, which you already use)
(use-package nerd-icons
  :defer t)

(use-package nerd-icons-dired
  :after (dired nerd-icons)
  :hook (dired-mode . nerd-icons-dired-mode)
  :commands (nerd-icons-dired-mode))

;; Dired sidebar for quick navigation
(use-package dired-sidebar
  :commands (dired-sidebar-toggle-sidebar)
  :custom
  (dired-sidebar-use-term-integration t)
  (dired-sidebar-use-custom-modeline t))

;; Ripgrep in Dired / directory using dired-rg
(use-package dired-rg
  :after (dired)
  :commands (dired-rg)
  :init
  ;; fallback to consult-ripgrep if desired:
  (with-eval-after-load 'general
    (my/leader-keys
      "s"  '(:ignore t :which-key "search")
      "sr" '(consult-ripgrep :which-key "ripgrep project"))))

;; Handy: wdired for in-place renaming (built-in)
(use-package wdired
  :ensure nil
  :commands (wdired-change-to-wdired-mode)
  :bind (:map dired-mode-map
              ("r" . wdired-change-to-wdired-mode)))

;; --------------------------------
;; Dashboard
;; --------------------------------
(use-package dashboard
  :ensure t
  :config
  (setq inhibit-startup-screen t
        initial-buffer-choice (lambda () (get-buffer "*dashboard*")) ;; always dashboard
        dashboard-startup-banner 'logo
        dashboard-banner-logo-title "Welcome back"
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-center-content t
        dashboard-show-shortcuts t
        dashboard-items '((recents  . 5)
                          (projects . 5))
        dashboard-image-banner-max-height 100
        dashboard-image-banner-max-width 200)

  ;; Optional custom logo
  (let ((img-path (expand-file-name "~/nixflakes/config/emacs/dashboard.png")))
    (when (file-exists-p img-path)
      (setq dashboard-banner-logo-png img-path)))

  ;; Startup hook
  (dashboard-setup-startup-hook)

  ;; Replace *scratch* in new emacsclient frames
  (defun my/dashboard-on-frame (&optional frame)
    "Open dashboard in FRAME if no file is opened."
    (with-selected-frame (or frame (selected-frame))
      (when (and (not (buffer-file-name))
                 (equal (buffer-name) "*scratch*"))
        (dashboard-open))))
  (add-hook 'after-make-frame-functions #'my/dashboard-on-frame)

  ;; For initial GUI startup (non-daemon)
  (add-hook 'emacs-startup-hook #'my/dashboard-on-frame))


(provide 'init)
;;; init.el ends here
