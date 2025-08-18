{ pkgs, config, ... }:
{
  services.emacs.enable = true;

  home.file.".emacs.d/init.el".source =
    config.lib.file.mkOutOfStoreSymlink /home/gabbar/nixflakes/config/emacs/emacs.el;

  programs.emacs = {
    enable = true;
    package =
      with pkgs;
      ((emacsPackagesFor emacs-gtk).emacsWithPackages (
        epkgs: with epkgs; [
          which-key
          vertico
          orderless
          consult
          consult-dir
          dashboard
          doom-themes
          doom-modeline
          evil
          evil-collection
          general

          projectile
          consult-projectile
          envrc

          corfu

          lsp-mode
          lsp-ui
          flycheck
          # lsp-treemacs  # only if you keep those treemacs bindings

          go-mode
          nix-mode
          web-mode
          typescript-mode # optional
          elsa

          transient
          magit

          avy
          multiple-cursors
        ]
      ));
  };
}
