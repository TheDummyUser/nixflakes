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

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--no-cmd"
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;


    shellAliases = {
      ll = "ls -l";
      update = "cd ~/flakes && sudo nixos-rebuild switch --flake .# && cd ~/";
      del = "sudo nix-collect-garbage -d && update";
      zed = "zeditor";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "eza"
        "fzf"
      ];
      theme = "gentoo";
    };
  };
}