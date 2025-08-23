{
  pkgs,
  config,
  lib,
  ...
}:
{

  home.packages = with pkgs; [
    # Spell checking
    (aspellWithDicts (
      dicts: with dicts; [
        en
        en-computers
        en-science
      ]
    ))

    # Language servers for LSP
    gopls # Go language server
    nil # Nix language server
    nixd # Alternative Nix language server

    # Additional tools that LSP might need
    gotools # Go development tools
    delve # Go debugger
  ];

  home.file.".emacs.d/init.el".source =
    config.lib.file.mkOutOfStoreSymlink /home/gabbar/nixflakes/config/emacs/emacs.el;

  programs.emacs = {
    enable = true;
    package =
      with pkgs;
      ((emacsPackagesFor emacs-gtk).emacsWithPackages (
        epkgs: with epkgs; [
          # Core framework packages
          evil # Vim keybindings
          evil-collection # Evil bindings for various modes
          undo-tree # Better undo system
          general # Key binding framework
          which-key # Key discovery and help

          # Completion and navigation
          ivy # Completion framework
          counsel # Collection of Ivy-enhanced commands
          swiper # Ivy-based search
          ivy-rich # Enhanced Ivy interface
          company # Auto-completion
          company-box # Better company UI

          # Project management
          projectile # Project interaction library
          counsel-projectile # Ivy integration for Projectile

          # Language Server Protocol (LSP)
          lsp-mode # Language Server Protocol client
          lsp-ui # UI modules for lsp-mode
          lsp-ivy # Ivy integration for LSP
          vterm

          # Language modes
          go-mode # Go language support
          nix-mode # Nix expression language support
          rjsx-mode
          lsp-tailwindcss

          # Development tools
          flycheck # Syntax checking
          direnv # Environment variable integration
          magit # Git interface
          smartparens # Automatic pairing

          # File management
          treemacs # File tree sidebar
          treemacs-evil # Evil bindings for Treemacs
          treemacs-projectile # Projectile integration for Treemacs

          # UI and themes
          doom-themes # Doom Emacs theme collection
          doom-modeline # Doom-style modeline
          all-the-icons # Icon fonts
          dashboard # Startup screen

          # Additional utilities
          helpful # Better help system
          perspective # Workspace management
          hydra # Key binding macros
          diff-hl

          # Tree-sitter support (optional but recommended)
          treesit-auto
          treesit-grammars.with-all-grammars

          # Additional LSP and development tools
          yasnippet # Snippet system
          yasnippet-snippets # Snippet collections
        ]
      ));
  };
}
