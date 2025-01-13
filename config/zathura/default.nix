{ config, pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      ### Settings from original zathurarc ###
      pages-per-row = "1";
      scroll-page-aware = "true";
      scroll-full-overlap = "0.01";
      scroll-step = "100";
      font = "JetbrainsMono Nerd Font 11";

      # Everblush Theme
      # Allow recolor
      recolor = "true";

      # Don't allow original hue when recoloring
      recolor-keephue = "true";

      # Don't keep original image colors while recoloring
      recolor-reverse-video = "false";

      default-bg = "#${config.colorScheme.palette.base00}";
      default-fg = "#${config.colorScheme.palette.base05}";

      statusbar-fg = "#${config.colorScheme.palette.base04}";
      statusbar-bg = "#${config.colorScheme.palette.base02}";

      inputbar-bg = "#${config.colorScheme.palette.base00}";
      inputbar-fg = "#${config.colorScheme.palette.base08}";

      notification-bg = "#${config.colorScheme.palette.base00}";
      notification-fg = "#${config.colorScheme.palette.base07}";

      notification-error-bg = "#${config.colorScheme.palette.base00}";
      notification-error-fg = "#${config.colorScheme.palette.base08}";

      notification-warning-bg = "#${config.colorScheme.palette.base00}";
      notification-warning-fg = "#${config.colorScheme.palette.base08}";

      highlight-color = "#${config.colorScheme.palette.base0A}";
      highlight-active-color = "#${config.colorScheme.palette.base0D}";

      completion-bg = "#${config.colorScheme.palette.base01}";
      completion-fg = "#${config.colorScheme.palette.base0D}";

      completion-highlight-fg = "#${config.colorScheme.palette.base07}";
      completion-highlight-bg = "#${config.colorScheme.palette.base0D}";

      recolor-lightcolor = "#${config.colorScheme.palette.base00}";
      recolor-darkcolor = "#${config.colorScheme.palette.base06}";

    };
  };
}
