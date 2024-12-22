{
  config,
  ...
}:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "bluetooth"
          "network"
          "tray"
          "custom/exit"
        ];

        "clock" = {
          "intervel" = 60;
          "format" = "󰥔 {:%H:%M}";
          "max-length" = 25;
        };

        "hyprland/workspaces" = {
          "format" = "{icon}";
          "tooltip" = "false";
          "all-outputs" = true;
          "sort-by-number" = true;
          "format-icons" = {
            "active" = " 󰮯 ";
            "default" = " 󰊠 ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        "hyprland/window" = {
          max-length = 22;
          separate-outputs = false;
          rewrite = {
            "" = "  No Windows?";
          };
        };

        "custom/exit" = {
          tooltip = false;
          format = "";
          on-click = "sleep 0.1 && wlogout";
        };

        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
          "exec" = "$HOME/nixflakes/scripts/swayidle-start.sh";
          "on-click" = "$HOME/nixflakes/scripts/swayidle-start.sh";
        };
        "tray" = {
          "icon-size" = 12;
          "spacing" = 5;
        };

        "bluetooth" = {
          "format" = " {status}";
          "format-connected" = " {device_alias}";
          "format-connected-battery" = " {device_alias} {device_battery_percentage}%";
          "format-device-preference" = [
            "device1"
            "device2"
          ]; # // preference list deciding the displayed device
          "tooltip-format" = ''
            {controller_alias}	{controller_address}

            {num_connections} connected'';
          "tooltip-format-connected" = ''
            {controller_alias}	{controller_address}

            {num_connections} connected

            {device_enumerate}'';
          "tooltip-format-enumerate-connected" = "{device_alias}	{device_address}";
          "tooltip-format-enumerate-connected-battery" =
            "{device_alias}	{device_address}	{device_battery_percentage}%";
        };

        "network" = {
          format-icons = [
            "󰤯 "
            "󰤟 "
            "󰤢 "
            "󰤥 "
            "󰤨 "
          ];
          format-ethernet = " {bandwidthDownOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };
        "pulseaudio" = {
          "format" = " {icon} {volume}%";
          "format-muted" = "󰝟";
          "tooltip" = false;
          "format-icons" = {
            "headphone" = "";
            "default" = [
              ""
              ""
              "󰕾"
              "󰕾"
              "󰕾"
              ""
              ""
              ""
            ];
          };
        };
      };
    };
    style = ''
      * {
              border: none;
              font-family:'FiraCode Nerd Font', 'Symbols Nerd Font Mono' ;
              font-size: 13px;
              font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
              min-height: 30px;
            }


            window#waybar {
             background: transparent;
            }

            #window, #clock,#workspaces,#tray,#bluetooth,#network,#pulseaudio, #idle_inhibitor, #custom-exit {
            background-color: #${config.colorScheme.palette.base00};
            color: #${config.colorScheme.palette.base06};
            border-radius: 5px;
            padding-left: 10px;
            padding-right: 10px;
            margin-top:5px;
            margin-right: 5px;
            }

            #tray,#bluetooth,#pulseaudio {
            margin-right: 5px;
            }

            #tray {
            font-size:12px;
            }

            #workspaces {
            padding: 0px 0px;
            margin-left: 5px;
            }
            #workspaces button {
            background-color: #${config.colorScheme.palette.base00};
            color: #${config.colorScheme.palette.base03};
            }

            #workspaces button.active {
            background: #${config.colorScheme.palette.base00};
            color: #${config.colorScheme.palette.base05};
            }
    '';
  };
}
