{ pkgs, config, ... }:
let
  bgImage = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/kx/wallhaven-kx5z9m.jpg";
    sha256 = "sha256-RImNeNmb2aYDvgpsFHi0R6IB2KcF3DGk3gE6rlL7JGE=";
  };

  foreground = "#${config.colorScheme.palette.base00}";
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = [
        {
          path = "${bgImage}";
          blur_passes = 2;
          blur_size = 4;
        }
      ];

      label = [
        {
          # Day-Month-Date
          monitor = "";
          text = ''cmd[update:1000] echo -e "$(date +"%A, %B %d")"'';
          color = foreground;
          font_size = 28;
          font_family = "JetBrainsMono Nerd Font";
          # position = "0, 490";
          halign = "center";
          valign = "top";
        }
        # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<span>$(date +"%I:%M")</span>"'';
          color = foreground;
          font_size = 300;
          font_family = "JetBrainsMono Nerd Font";
          # position = "0, 370";
          halign = "center";
          valign = "center";
        }

        # {
        #   monitor="";
        #   text = '' 󰐥  󰜉  󰤄 '';
        #   font_size = 50;
        #   font_family = "JetBrainsMono Nerd Font";
        #   position = "20,20,50,20";
        #   halign = "right";
        #   valign = "bottom";
        # }
      ];
      input-field = [
        {

          size = "200, 50";
          position = "0, 20";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_family = "JetBrainsMono Nerd Font";
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 2;
          placeholder_text = ''<span foreground="##cad3f5">********</span>'';
          shadow_passes = 2;
          valign="bottom";
        }
      ];
    };
    package = pkgs.hyprlock;
  };
}
