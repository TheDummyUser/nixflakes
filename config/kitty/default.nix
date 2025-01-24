{
  config,
  ...
}:

{
  programs.kitty = {
    enable = true;
    settings = with config.colorScheme.palette; {
      # font
      font_family = "JetBrainsMono Nerd Font";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = 10;

      #pages
      "ctrl+shift+up" = "scroll_line_up";
      "ctrl+shift+down" = "scroll_line_down";
      "ctrl+shift+k" = "scroll_line_up";
      "ctrl+shift+j" = "scroll_line_down";

      #curosr
      cursor_spape = "block";

      scrollback_line = 2000;

      # bell
      enable_audio_bell = "no";
      window_alert_on_bell = "no";
      detect_url = "yes";
      url_style = "curly";
      url_prefixes = "file ftp ftps gemini git gopher http https irc ircs kitty mailto news sftp ssh";
      show_hyperlink_targets = "yes";
      underline_hyperlinks = "hover";
      confirm_os_window_close = 0;

      #border
      window_padding_width = 10;

      background = "#${base00}";
      foreground = "#${base05}";
      section_background = "#${base00}";
      section_foreground = "#${base05}";
      url_color = "#${base04}";
      cursor = "#${base05}";
      active_border_color = "#${base03}";
      inactive_border_color = "#${base01}";
      active_tab_backgroud = "#${base00}";
      active_tab_foreground = "#${base05}";
      inactive_tab_background = "#${base01}";
      inactive_tab_foreground = "#${base01}";
      tab_bar_background = "#${base01}";

      # normal colors
      color0 = "#${base00}";
      color1 = "#${base08}";
      color2 = "#${base0B}";
      color3 = "#${base0A}";
      color4 = "#${base0D}";
      color5 = "#${base0E}";
      color6 = "#${base0C}";
      color7 = "#${base05}";

      # bright colors
      color8 = "#${base03}";
      color9 = "#${base08}";
      color10 = "#${base0B}";
      color11 = "#${base0A}";
      color12 = "#${base0D}";
      color13 = "#${base0E}";
      color14 = "#${base0C}";
      color15 = "#${base07}";

      # extended colors

      color16 = "#${base09}";
      color17 = "#${base0F}";
      color18 = "#${base01}";
      color19 = "#${base02}";
      color20 = "#${base04}";
      color21 = "#${base06}";

    };
  };
}
