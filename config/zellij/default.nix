{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.zellij = {
    enable = true;
    settings = {
      default_layout = "compact";
      mouse_mode = true;
      theme = "custom";
      themes = {
        custom.fg = "#${config.colorScheme.palette.base05}";
        custom.bg = "#${config.colorScheme.palette.base00}";
        custom.red = "#${config.colorScheme.palette.base08}";
        custom.green = "#${config.colorScheme.palette.base0B}";
        custom.blue = "#${config.colorScheme.palette.base0D}";
        custom.yellow = "#${config.colorScheme.palette.base0A}";
        custom.magenta = "#${config.colorScheme.palette.base0C}";
        custom.orange = "#${config.colorScheme.palette.base09}";
        custom.cyan = "#${config.colorScheme.palette.base06}";
        custom.black = "#${config.colorScheme.palette.base01}";
        custom.white = "#${config.colorScheme.palette.base05}";
      };
    };
  };
}
