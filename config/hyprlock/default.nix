{ pkgs, config, ... }:
let
  bgImage = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/m3/wallhaven-m3j731.png";
    sha256 = "sha256-UfjyX/ee2zHrl4hn4haFTlvqgIz1IelIEka4ucNQlIM=";
  };
  userImg = pkgs.fetchurl {
    url = "https://i.pinimg.com/736x/01/b8/61/01b86133f313abc0486aba7297904f65.jpg";
    sha256 = "sha256-hd7C/7epyBIbPNwSu2Rv5ArBeHTeorVzaU1Rbj4Pve4=";
  };
  foreground = "rgba(216, 222, 233, 0.70)";
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
      image = {
        path = "${userImg}";
        size = 100;
        rounding = 0;
        position = "0, 100";
        halign = "center";
        valign = "center";
        outer_color = "rgb(24, 25, 38)";
        outline_thickness = 2;
      };

      label = [
        {
          # Day-Month-Date
          monitor = "";
          text = ''cmd[update:1000] echo -e "$(date +"%A, %B %d")"'';
          color = foreground;
          font_size = 28;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 490";
          halign = "center";
          valign = "center";
        }
        # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<span>$(date +"%I:%M")</span>"'';
          color = foreground;
          font_size = 160;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 370";
          halign = "center";
          valign = "center";
        }
        # USER
        {
          monitor = "";
          text = "    $USER";
          color = foreground;
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          font_size = 18;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -180";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = [
        {

          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_family = "JetBrainsMono Nerd Font";
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 2;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];
    };
    package = pkgs.hyprlock;
  };
}
