{
  config,
  lib,
  pkgs,
  ...
}:
{
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
    shellAliases = {
      ll = "ls -l";
      update = "cd ~/nixflakes && sudo nixos-rebuild switch --flake .#default && cd ~/";
      del = "sudo nix-collect-garbage -d && update";
      zed = "zeditor";
      doom = "~/.config/emacs/doom";
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
