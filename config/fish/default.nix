{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    colors = "always";
    icons = "always";
    enableFishIntegration = true;
  };

  home.packages = with pkgs; [
# fish plugins start
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    fasd
    # fish plugins end
  ]

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      pokemon-colorscripts -r --no-title

      # bobthefish theme options
      set -g theme_nerd_fonts yes
      set -g theme_color_scheme solarized-dark
      set -g theme_display_git yes
      set -g theme_display_virtualenv yes

      # Set theme (if available)
      fish_config theme choose bobthefish
    '';

    generateCompletions = true;

    shellAliases = {
      ll = "ls -l";
      update = "cd ~/nixflakes && sudo nixos-rebuild switch --flake .# && cd ~/";
      del = "sudo nix-collect-garbage -d && update";
      zed = "zeditor";
    };

    plugins = [
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "fasd";
        src = pkgs.fishPlugins.grc.src;
      }
    ];
  };
}
