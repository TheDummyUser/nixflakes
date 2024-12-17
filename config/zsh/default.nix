{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "cd ~/nixflakes && sudo nixos-rebuild switch --flake .#default &&cd ~/";
    };
    oh-my-zsh = {
      enable = true;
      # plugins = [ "git" "thefuck" ];
      theme = "gentoo";
    };
  };
}
