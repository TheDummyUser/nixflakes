{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs = {
    foot = {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";

          font = "JetBrainsMono Nerd Font:size=10";
          dpi-aware = "no";
          pad = "10x10";
        };

        mouse = {
          hide-when-typing = "yes";
        };
        cursor = {
          style = "beam";
          beam-thickness = 2;
          blink = "yes";
        };
        bell = {
          urgent = "no";
          notify = "no";
          visual = "no";
        };
        url = {
          launch = "xdg-open \${url}";
          label-letters = "sadfjklewcmpgh";
          osc8-underline = "url-mode";
          protocols = "http, https, ftp, ftps, file, gemini, gopher";
          uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=''() []\\";

        };
        colors = {
          alpha = 1.0;
          background = "${config.colorScheme.palette.base00}";
          foreground = "${config.colorScheme.palette.base05}";

          # regular
          regular0 = "${config.colorScheme.palette.base00}";
          regular1 = "${config.colorScheme.palette.base08}";
          regular2 = "${config.colorScheme.palette.base0B}";
          regular3 = "${config.colorScheme.palette.base0A}";
          regular4 = "${config.colorScheme.palette.base0D}";
          regular5 = "${config.colorScheme.palette.base0E}";
          regular6 = "${config.colorScheme.palette.base0C}";

          #bright
          bright0 = "${config.colorScheme.palette.base03}";
          bright1 = "${config.colorScheme.palette.base08}";
          bright2 = "${config.colorScheme.palette.base0B}";
          bright3 = "${config.colorScheme.palette.base0A}";
          bright4 = "${config.colorScheme.palette.base0D}";
          bright7 = "${config.colorScheme.palette.base0E}";
        };
      };
    };
  };
}
