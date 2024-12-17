{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./zsh
    ./git
    ./hyprland
    ./kitty
    ./waybar
  ];
}
