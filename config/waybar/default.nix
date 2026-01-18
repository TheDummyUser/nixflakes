{config, ...} :

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "bluetooth"
          "tray"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          format = "{id}";
        };

        "pulseaudio" = {
          format = "vol: {volume}";
          format-muted = "vol: muted";
        };

        "bluetooth" = {
          format-on = "bt: on ({num_connections})";
          format-off = "bt: off";
          format-disabled = "bt: off";
        };

        "clock" = {
          format = "{:%d %m %y | %I:%M %p}";
        };

        "tray" = {
          spacing = 6;
        };

        "custom/power" = {
          format = "pwr";
          on-click = "~/.config/rofi/powermenu/type-6/powermenu.sh";
          tooltip = false;
        };
      };
    };

    style = ''
      * {
        border: none;
        font-family: "Iosevka Nerd Font", "FiraCode Nerd Font", "Symbols Nerd Font Mono";
        font-size: 15px;
        padding: 0;
        margin: 0;
      }

      window#waybar {
        background: #${config.colorScheme.palette.base00};
        color: #${config.colorScheme.palette.base06};
      }

      /* --- Workspaces --- */
      #workspaces {
        padding-left: 0px;
        background: #${config.colorScheme.palette.base01};
        margin: 0px;
        border-radius: 0px;
      }

      #workspaces button {
        padding: 0 6px;
        background: transparent;
        color: #${config.colorScheme.palette.base03};
      }

      #workspaces button.active {
        background: #${config.colorScheme.palette.base02};
        color: #${config.colorScheme.palette.base05};
                border-radius: 0px;
      }

      /* --- Right modules --- */
      #pulseaudio,
      #bluetooth,
      #clock,
      #tray,
      #custom-power {
        color: #${config.colorScheme.palette.base06};
        padding: 0 6px;
        margin: 5px 5px 5px 0;
        border-radius: 5px;
      }

      /* --- Power hover --- */
      #custom-power:hover {
        background: #${config.colorScheme.palette.base02};
        color: #${config.colorScheme.palette.base08};
      }
    '';
  };
}
