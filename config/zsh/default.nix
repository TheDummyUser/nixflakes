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

    # Custom function
    initExtra = ''
      run() {
        PROJECT_ROOT="/home/gabbar/projects/tcpp"
        mkdir -p "$PROJECT_ROOT/bin"
        filename=$(basename "$1" .cpp)
        g++ -o "$PROJECT_ROOT/bin/$filename.out" "$1" && \
        "$PROJECT_ROOT/bin/$filename.out"
      }
    '';
  };
}
