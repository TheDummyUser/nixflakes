{ config, pkgs, ... }:
{
  # Required services for bspwm
  services.picom.enable = true;
  services.network-manager-applet.enable = true;

  # Bspwm configuration files
  xdg.configFile = {
    "bspwm/bspwmrc" = {
      text = ''
        #!/usr/bin/env bash
        # Reset BSPWM rules
        bspc rule -r "*"

        # Kill existing processes
        pkill -x sxhkd
        pkill -x picom
        pkill -x dunst
        pkill -x nm-applet
        pkill -x polybar

        # Start necessary processes
        sxhkd &
        xrdb ~/.Xresources &
        xsetroot -cursor_name left_ptr &
        picom -b &
        nm-applet &
        dunst &
        vesktop &

        # Set up display
        xrandr --output HDMI-2 --mode 1920x1080 --rate 60 &
        feh --bg-fill /mnt/Localdisk/folder/wall/cat.png &

        # Prepare lockscreen image (betterlockscreen)
        betterlockscreen -u /mnt/Localdisk/folder/wall/cat.png &

        # Launch Polybar
        ~/.config/polybar/launch.sh &

        # Set up BSPWM workspaces
        bspc monitor HDMI-2 -d 1 2 3 4 5 6 7 8 9

        # Window rules
        bspc rule -a Emacs state=tiled
        bspc rule -a Firefox desktop=^1
        bspc rule -a Vesktop desktop=^9
        bspc rule -a "*:*:Calculator" state=floating center=true

        # BSPWM configuration
        bspc config automatic_scheme alternate
        bspc config initial_polarity second_child
        bspc config split_ratio 0.52
        bspc config borderless_monocle true
        bspc config gapless_monocle true
        bspc config single_monocle false

        # Focus and window behavior
        bspc config pointer_follows_monitor true
        bspc config focus_follows_pointer true
        bspc config history_aware_focus true

        # Window appearance
        bspc config border_width 1
        bspc config window_gap 5
        bspc config normal_border_color "#${config.colorScheme.palette.base03}"
        bspc config focused_border_color "#${config.colorScheme.palette.base09}"
        bspc config urgent_border_color "#${config.colorScheme.palette.base08}"
        bspc config presel_border_color "#${config.colorScheme.palette.base06}"
      '';
      executable = true;
    };

    "sxhkd/sxhkdrc" = {
      text = ''
        ##############################
        #   sxhkd configuration
        ##############################

        # --- Applications ---
        super + w
            firefox

        super + t
            kitty

        super + e
            thunar

        super + r
            rofi -show drun

        super + shift + r
            rofi -show run

        # --- System ---
        super + shift + c
            bspc wm -r

        super + space
            $HOME/nixflakes/randomImagePicker/fehbg

        # safer quit (avoid accidental WM kill)
        super + ctrl + alt + q
            pkill bspwm

        # --- Power management / Lock ---
        # Lock (uses betterlockscreen; blur variant)
        super + ctrl + l
            betterlockscreen -l blur

        # Power actions (may require appropriate permissions / polkit)
        super + ctrl + alt + p
            systemctl poweroff

        super + ctrl + alt + r
            systemctl reboot

        super + ctrl + alt + s
            systemctl suspend

        # --- Window management ---
        super + q
            bspc node -c

        super + shift + k
            bspc node -k

        # Rotate
        super + j
            bspc node -R 90
        super + shift + j
            bspc node -R -90

        # Window states
        super + shift + t
            bspc node -t tiled
        super + shift + f
            bspc node -t fullscreen
        super + shift + s
            bspc node -t floating
        super + f
            bspc node -t pseudo_tiled

        # Toggle monocle layout
        super + m
            bspc desktop -l next

        # --- Focus & Movement ---
        # Focus windows
        super + h
            bspc node -f west
        super + j
            bspc node -f south
        super + k
            bspc node -f north
        super + l
            bspc node -f east

        # Move windows
        super + shift + h
            bspc node -s west
        super + shift + j
            bspc node -s south
        super + shift + k
            bspc node -s north
        super + shift + l
            bspc node -s east

        # --- Desktop switching ---
        # Switch to desktop
        super + {1-9,0}
            bspc desktop -f {1-9,10}

        # Send node to desktop and follow (Hyprland-like)
        super + shift + {1-9,0}
            bspc node -d {1-9,10} --follow

        # --- Preselection ---
        super + ctrl + h
            bspc node -p west
        super + ctrl + j
            bspc node -p south
        super + ctrl + k
            bspc node -p north
        super + ctrl + l
            bspc node -p east

        super + ctrl + space
            bspc node -p cancel

        # --- Resize floating windows ---
        # Expand
        super + alt + h
            bspc node -z left -20 0
        super + alt + l
            bspc node -z right 20 0
        super + alt + k
            bspc node -z top 0 -20
        super + alt + j
            bspc node -z bottom 0 20

        # Contract
        super + alt + shift + h
            bspc node -z right -20 0
        super + alt + shift + l
            bspc node -z left 20 0
        super + alt + shift + k
            bspc node -z bottom -20 0
        super + alt + shift + j
            bspc node -z top 20 0

        # Move floating windows
        super + alt + ctrl + h
            bspc node -v -20 0
        super + alt + ctrl + l
            bspc node -v 20 0
        super + alt + ctrl + k
            bspc node -v 0 -20
        super + alt + ctrl + j
            bspc node -v 0 20

        # --- Volume (check with `xev` if keys differ) ---
        XF86AudioRaiseVolume
            pamixer -i 5

        XF86AudioLowerVolume
            pamixer -d 5

        XF86AudioMute
            pamixer -t

        # --- Screenshot ---
        Print
            maim -s | xclip -selection clipboard -t image/png

        super + Print
            maim | xclip -selection clipboard -t image/png
      '';
    };

    # Enhanced Picom Configuration (Based on gh0stzk's setup)
    "picom/picom.conf" = {
      text = ''
        #################################
        #           Shadows             #
        #################################
        shadow = true;
        shadow-radius = 7;
        shadow-offset-x = -7;
        shadow-offset-y = -7;
        shadow-color = "#000000";

        #################################
        #           Fading              #
        #################################
        fading = true;
        fade-in-step = 0.03;
        fade-out-step = 0.03;
        fade-delta = 5;
        no-fading-openclose = false;
        no-fading-destroyed-argb = false;

        #################################
        #       Transparency            #
        #################################
        frame-opacity = 1.0;

        #################################
        #           Corners             #
        #################################
        corner-radius = 0;

        #################################
        #       General Settings        #
        #################################
        backend = "glx";
        dithered-present = false;
        vsync = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        detect-transient = true;
        use-damage = true;

        #################################
        #             Blur              #
        #################################
        blur: {
          method = "gaussian";
          size = 10;
          deviation = 2.5;
        }

        #################################
        #          Animation Rules      #
        #################################
        animations = true;

        rules: (
          # Default rule - no animations for maximum compatibility
          {
            blur-background = false;
            fade = false;
          },

          # Normal windows
          {
            match = "window_type = 'normal'";
            fade = true;
            shadow = true;
            animations = (
              # Close animation
              {
                triggers = ["close"];
                opacity = {
                  curve = "cubic-bezier(0,1,1,1)";
                  duration = 0.3;
                  start = "window-raw-opacity-before";
                  end = 0;
                };
                blur-opacity = "opacity";
                shadow-opacity = "opacity";
                scale-x = {
                  curve = "cubic-bezier(0,1.3,1,1)";
                  duration = 0.3;
                  start = 1;
                  end = 0.6;
                };
                scale-y = "scale-x";
                offset-x = "(1 - scale-x) / 2 * window-width";
                offset-y = "(1 - scale-y) / 2 * window-height";
                shadow-scale-x = "scale-x";
                shadow-scale-y = "scale-y";
                shadow-offset-x = "offset-x";
                shadow-offset-y = "offset-y";
              },
              # Open animation
              {
                triggers = ["open"];
                opacity = {
                  curve = "cubic-bezier(0,1,1,1)";
                  duration = 0.5;
                  start = 0;
                  end = "window-raw-opacity";
                };
                blur-opacity = "opacity";
                shadow-opacity = "opacity";
                scale-x = {
                  curve = "cubic-bezier(0,1.3,1,1)";
                  duration = 0.5;
                  start = 0.6;
                  end = 1;
                };
                scale-y = "scale-x";
                offset-x = "(1 - scale-x) / 2 * window-width";
                offset-y = "(1 - scale-y) / 2 * window-height";
                shadow-scale-x = "scale-x";
                shadow-scale-y = "scale-y";
                shadow-offset-x = "offset-x";
                shadow-offset-y = "offset-y";
              },
              # Geometry animation
              {
                triggers = ["geometry"];
                scale-x = {
                  curve = "cubic-bezier(0,0,0,1.28)";
                  duration = 0.5;
                  start = "window-width-before / window-width";
                  end = 1;
                };
                scale-y = {
                  curve = "cubic-bezier(0,0,0,1.28)";
                  duration = 0.5;
                  start = "window-height-before / window-height";
                  end = 1;
                };
                offset-x = {
                  curve = "cubic-bezier(0,0,0,1.28)";
                  duration = 0.5;
                  start = "window-x-before - window-x";
                  end = 0;
                };
                offset-y = {
                  curve = "cubic-bezier(0,0,0,1.28)";
                  duration = 0.5;
                  start = "window-y-before - window-y";
                  end = 0;
                };
                shadow-scale-x = "scale-x";
                shadow-scale-y = "scale-y";
                shadow-offset-x = "offset-x";
                shadow-offset-y = "offset-y";
              }
            )
          },

          # Dialog windows
          {
            match = "window_type = 'dialog'";
            shadow = true;
          },

          # Tooltip windows
          {
            match = "window_type = 'tooltip'";
            corner-radius = 0;
            opacity = 0.90;
          },

          # Fullscreen windows
          {
            match = "fullscreen";
            corner-radius = 0;
          },

          # Dock windows (like panels)
          {
            match = "window_type = 'dock'";
            corner-radius = 0;
            fade = true;
          },

          # Dropdown/popup menus
          {
            match = "window_type = 'dropdown_menu' || window_type = 'menu' || window_type = 'popup' || window_type = 'popup_menu'";
            corner-radius = 0;
          },

          # Fix shadow bugs on small UI elements
          {
            match = "window_type = 'menu' || role = 'popup' || role = 'bubble'";
            shadow = false;
          },

          # Terminal windows (Alacritty/kitty)
          {
            match = "class_g = 'Alacritty' || class_g = 'kitty' || class_g = 'FloaTerm'";
            opacity = 1.0;
            blur-background = false;
          },

          # Scratchpad and updating windows
          {
            match = "class_g = 'bspwm-scratch' || class_g = 'Updating'";
            opacity = 0.93;
            blur-background = false;
          },

          # Special applications - no rounded corners
          {
            match = "class_g = 'Polybar' || "
                   "class_g = 'eww-bar' || "
                   "class_g = 'Viewnior' || "
                   "class_g = 'Rofi' || "
                   "class_g = 'mpv' || "
                   "class_g = 'bspwm-scratch' || "
                   "class_g = 'Dunst' || "
                   "class_g = 'retroarch'";
            corner-radius = 0;
          },

          # No shadows for specific applications
          {
            match = "name = 'Notification' || "
                   "class_g ?= 'Notify-osd' || "
                   "class_g = 'Dunst' || "
                   "class_g = 'Polybar' || "
                   "class_g = 'Eww' || "
                   "class_g = 'jgmenu' || "
                   "class_g = 'bspwm-scratch' || "
                   "class_g = 'Spotify' || "
                   "class_g = 'retroarch' || "
                   "class_g = 'firefox' || "
                   "class_g = 'Rofi' || "
                   "class_g = 'Screenkey' || "
                   "class_g = 'mpv' || "
                   "class_g = 'Viewnior' || "
                   "_GTK_FRAME_EXTENTS@";
            shadow = false;
          },

          # Rofi animations
          {
            match = "class_g = 'Rofi'";
            animations = (
              {
                triggers = ["close", "hide"];
                preset = "disappear";
                duration = 0.05;
                scale = 0.5;
              },
              {
                triggers = ["open", "show"];
                preset = "appear";
                duration = 0.2;
                scale = 0.5;
              }
            )
          },

          # Dunst notification animations
          {
            match = "class_g = 'Dunst'";
            animations = (
              {
                triggers = ["close", "hide"];
                preset = "fly-out";
                direction = "up";
                duration = 0.2;
              },
              {
                triggers = ["open", "show"];
                preset = "fly-in";
                direction = "up";
                duration = 0.2;
              }
            )
          },

          # Jgmenu animations
          {
            match = "class_g = 'jgmenu'";
            animations = (
              {
                triggers = ["close", "hide"];
                preset = "disappear";
                duration = 0.08;
                scale = 0.5;
              },
              {
                triggers = ["open", "show"];
                preset = "appear";
                duration = 0.15;
                scale = 0.5;
              }
            )
          },

          # Scratchpad animations
          {
            match = "class_g = 'bspwm-scratch'";
            animations = (
              {
                triggers = ["close", "hide"];
                preset = "fly-out";
                direction = "up";
                duration = 0.2;
              },
              {
                triggers = ["open", "show"];
                preset = "fly-in";
                direction = "up";
                duration = 0.2;
              }
            )
          }
        );
      '';
    };

    "polybar/config.ini" = {
      text = with config.colorScheme.palette; ''
        [colors]
        background = #${base00}
        foreground = #${base07}
        primary = #${base09}
        secondary = #${base0A}
        alert = #${base08}
        disabled = #${base03}

        [bar/main]
        width = 100%
        height = 20pt
        radius = 0

        background = ''${colors.background}
        foreground = ''${colors.foreground}

        line-size = 2pt
        border-size = 0pt
        padding-left = 1
        padding-right = 1
        module-margin = 1

        separator = |
        separator-foreground = ''${colors.disabled}

        font-0 = "JetBrainsMono Nerd Font:size=9;2"
        font-1 = "Font Awesome 6 Free:style=Solid:size=9;2"
        font-2 = "Font Awesome 6 Brands:size=9;2"

        modules-left = bspwm
        modules-center = date
        modules-right = pulseaudio memory cpu wlan tray

        cursor-click = pointer
        cursor-scroll = ns-resize

        enable-ipc = true

        [module/bspwm]
        type = internal/bspwm

        label-focused = %index%
        label-focused-background = ''${colors.primary}
        label-focused-foreground = ''${colors.background}
        label-focused-padding = 2

        label-occupied = %index%
        label-occupied-padding = 2
        label-occupied-background = ''${colors.secondary}
        label-occupied-foreground = ''${colors.background}

        label-urgent = %index%!
        label-urgent-background = ''${colors.alert}
        label-urgent-padding = 2

        label-empty = %index%
        label-empty-foreground = ''${colors.disabled}
        label-empty-padding = 2

        [module/date]
        type = internal/date
        interval = 1

        date = %a %b %d
        time = %H:%M:%S

        label =  %date%  %time%
        label-foreground = ''${colors.foreground}

        [module/pulseaudio]
        type = internal/pulseaudio

        format-volume-prefix = "  "
        format-volume-prefix-foreground = ''${colors.primary}
        format-volume = <label-volume>

        label-volume = %percentage%%

        label-muted =
        label-muted-foreground = ''${colors.disabled}

        [module/memory]
        type = internal/memory
        interval = 2
        format-prefix = " 󱁉 "
        format-prefix-foreground = ''${colors.primary}
        label = %percentage_used:2%%

        [module/cpu]
        type = internal/cpu
        interval = 2
        format-prefix = " 󰻠 "
        format-prefix-foreground = ''${colors.primary}
        label = %percentage:2%%

        [module/wlan]
        type = internal/network
        interface-type = wireless
        format-prefix = " 󰖩 "
        interval = 3.0

        format-connected = <ramp-signal> <label-connected>
        label-connected = %essid%

        format-disconnected = <label-disconnected>
        label-disconnected =
        label-disconnected-foreground = ''${colors.disabled}

        ramp-signal-0 =
        ramp-signal-1 =
        ramp-signal-2 =
        ramp-signal-3 =
        ramp-signal-4 =
        ramp-signal-foreground = ''${colors.primary}

        [module/tray]
        type = internal/tray
        format-margin = 8pt
        tray-spacing = 4pt
        tray-scale = 0.8
        tray-maxsize = 20

        [settings]
        screenchange-reload = true
        pseudo-transparency = true
      '';
    };

    "polybar/launch.sh" = {
      text = ''
        #!/usr/bin/env bash

        # Terminate already running bar instances
        killall -q polybar

        # Wait until the processes have been shut down
        while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

        # Launch main bar
        echo "---" | tee -a /tmp/polybar1.log
        polybar main 2>&1 | tee -a /tmp/polybar1.log & disown

        echo "Polybar launched..."
      '';
      executable = true;
    };

    "polybar/colors.ini" = {
      text = with config.colorScheme.palette; ''
        [colors]
        base00 = #${base00}
        base01 = #${base01}
        base02 = #${base02}
        base03 = #${base03}
        base04 = #${base04}
        base05 = #${base05}
        base06 = #${base06}
        base07 = #${base07}
        base08 = #${base08}
        base09 = #${base09}
        base0A = #${base0A}
        base0B = #${base0B}
        base0C = #${base0C}
        base0D = #${base0D}
        base0E = #${base0E}
        base0F = #${base0F}
      '';
    };
  };

  home.packages = with pkgs; [
    # Essential packages
    feh
    maim
    xclip
    pamixer
    rofi
    polybar

    # Additional useful packages for bspwm
    sxhkd
    bspwm
    xorg.xrandr
    xorg.xsetroot
    networkmanager_dmenu
    playerctl
    dunst
    picom
    betterlockscreen # 🔒 Added lockscreen
    i3lock-color
  ];
}
