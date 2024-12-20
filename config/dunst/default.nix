{ config, pkgs, ... }:
{
  services.dunst = {
    package = pkgs.dunst;
    enable = true;
    settings = {
      global = {
        font = "JetbrainsMono Nerd Font 10";
        markup = "full";
        format = ''
          %s
          %b'';
        sort = "no";
        indicate_hidden = "yes";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = "yes";
        ignore_newline = "no";
        stack_duplicates = "false";
        hide_duplicate_count = "yes";
        corner_radius = 0;
        width = "280";
        height = "50-10";
        offset = "10x30";
        shrink = "no";
        idle_threshold = 120;
        monitor = 0;
        follow = "mouse";
        sticky_history = "yes";
        history_length = 20;
        show_indicators = "no";
        line_height = 4;
        separator_height = 4;
        padding = 20;
        horizontal_padding = 20;
        separator_color = "auto";
        startup_notification = "true";
        browser = "x-www-browser -new-tab";
        always_run_script = "true";
        title = "Dunst";
        class = "Dunst";
        icon_position = "left";
        min_icon_size = "32";
        max_icon_size = "56";
        frame_width = "3";

        timeout = 3;

        frame-color = "#${config.colorScheme.palette.base05}";

        separator-color = "#${config.colorScheme.palette.base05}";
      };

      urgency-normal = {
        foreground = "#${config.colorScheme.palette.base05}";
        background = "#${config.colorScheme.palette.base02}";

      };

      urgency-critical = {
        foreground = "#${config.colorScheme.palette.base06}";
        background = "#${config.colorScheme.palette.base08}";
      };
    };
  };
}
