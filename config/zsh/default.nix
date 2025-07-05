{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.eza = {
    enable = true;
    colors = "always";
    icons = "always";
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = "clear && pokemon-colorscripts -r --no-title";
    shellAliases = {
      ll = "ls -l";
      update = "cd ~/nixflakes && sudo nixos-rebuild switch --flake .# && cd ~/";
      del = "sudo nix-collect-garbage -d && update";
      zed = "zeditor";
      doom = "~/.config/emacs/bin/doom";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "thefuck"
        "eza"
        "fzf"
        "direnv"
      ];
      theme = "gentoo";
    };
  };
}
