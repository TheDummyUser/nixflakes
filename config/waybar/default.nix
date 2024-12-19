{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 33;
        modules-left = [ "clock" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [
          "pulseaudio"
          "tray"
          "bluetooth"
          "network"
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
          #"persistent-workspaces" = {
          #  "*" = 9; # 5 workspaces by default on every monitor
          # };
        };

        "tray" = {
          "icon-size" = 13;
          "spacing" = 6;
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
          "interface" = [
            "enp2s0"
            "wlp0s20f0u5"
          ];
          "format" = "{ifname}";
          "format-wifi" = "󰤨 {essid}";
          "format-ethernet" = "{ifname}";
          "format-disconnected" = "󰤭 No Network";
          "tooltip" = false;
        };
        "pulseaudio" = {
          "format" = " {icon} {volume}%";
          "format-muted" = "󰝟";
          "tooltip" = false;
          "format-icons" = {
            "headphone" = " ";
            "default" = [
              ""
              ""
              "󰕾"
              "󰕾"
              "󰕾"
              " "
              " "
              " "
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
              min-height: 35px;
            }


            window#waybar {
             background: #${config.colorScheme.palette.base00};
            }

            #clock,#workspaces,#tray,#bluetooth,#network,#pulseaudio {
            background-color: #${config.colorScheme.palette.base02};
            color: #${config.colorScheme.palette.base07};
            border-radius: 5px;
            padding-left: 10px;
            padding-right: 10px;
            margin-top: 8px;
            margin-right: 5px;
            margin-bottom: 8px;
            }

            #clock {
            margin-left: 5px;
            }

            #tray,#bluetooth,#pulseaudio {
            margin-right: 5px;
            }

            #tray {
            font-size:16px;
            }
            #workspaces {
            padding: 0px 0px
            }
            #workspaces button {
            background-color: #${config.colorScheme.palette.base02};
            color: #${config.colorScheme.palette.base03};
            }

            #workspaces button.active {
            background: #${config.colorScheme.palette.base01};
            color: #${config.colorScheme.palette.base08};
            }

    '';

  };
}
