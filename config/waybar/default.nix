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
        height = 20;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "bluetooth"
          "network"
          "tray"
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
          # max-length = 22;
          separate-outputs = false;
          rewrite = {
            "" = "  No Windows?";
          };
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
          "format" = " {icon}  {volume}% ";
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
              font-family :  'JetBrainsMono Nerd Font', 'FiraCode Nerd Font', 'Symbols Nerd Font Mono';
              font-size: 13px;
              font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
              min-height: 20px;
            }


            window#waybar {
             background: #${config.colorScheme.palette.base00};
            }

            #window, #clock,#workspaces,#tray,#bluetooth,#network,#pulseaudio, #idle_inhibitor, #custom-exit {
            background-color: #${config.colorScheme.palette.base01};
            color: #${config.colorScheme.palette.base06};
            border-radius: 0px;
            padding-left: 5px;
            padding-right: 5px;
            margin-top:5px;
            margin-right: 5px;
            margin-bottom: 5px;
            }

            #tray,#bluetooth,#pulseaudio {
            margin-right: 5px;
            }

            #tray {
            font-size:13px;
            }

            #workspaces {
            padding: 0px 0px;
            margin-left: 5px;
            }
            #workspaces button {
            background-color: #${config.colorScheme.palette.base01};
            color: #${config.colorScheme.palette.base03};
            }

            #workspaces button.active {
            border-radius: 0px;
            background: #${config.colorScheme.palette.base02};
            color: #${config.colorScheme.palette.base05};
            }
    '';
  };
}
