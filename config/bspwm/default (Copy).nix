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

        # Launch Polybar
        ~/.config/polybar/launch.sh &

        # Set up BSPWM workspaces
        bspc monitor HDMI-2 -d 1 2 3 4 5 6 7 8 9

        # Window rules
        bspc rule -a Emacs state=tiled
        bspc rule -a Firefox desktop=^1
        bspc rule -a discord desktop=^9
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
        bspc config border_width 2
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


        # --- Window management ---
        # Close / kill
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
        super + 1
            bspc desktop -f 1
        super + 2
            bspc desktop -f 2
        super + 3
            bspc desktop -f 3
        super + 4
            bspc desktop -f 4
        super + 5
            bspc desktop -f 5
        super + 6
            bspc desktop -f 6
        super + 7
            bspc desktop -f 7
        super + 8
            bspc desktop -f 8
        super + 9
            bspc desktop -f 9
        super + 0
            bspc desktop -f 10

        # Send node to desktop
        super + shift + 1
            bspc node -d 1
        super + shift + 2
            bspc node -d 2
        super + shift + 3
            bspc node -d 3
        super + shift + 4
            bspc node -d 4
        super + shift + 5
            bspc node -d 5
        super + shift + 6
            bspc node -d 6
        super + shift + 7
            bspc node -d 7
        super + shift + 8
            bspc node -d 8
        super + shift + 9
            bspc node -d 9
        super + shift + 0
            bspc node -d 10


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

    # Advanced Picom Configuration with Animations
    "picom/picom.conf" = {
      text = with config.colorScheme.palette; ''
        #################################
        # Animations                    #
        #################################
        # Modern picom animations using libconfig syntax
        animations = (
          {
            triggers = ["close", "hide"];
            preset = "slide-out";
            direction = "down";
            duration = 0.1;
          },
          {
            triggers = ["open", "show"];
            preset = "slide-in";
            direction = "up";
            duration = 0.1;
          },
          {
            triggers = ["geometry"];
            preset = "geometry-change";
            duration = 0.1;
          }
        );

        #################################
        # Shadows                       #
        #################################
        shadow = true;
        shadow-radius = 12;
        shadow-opacity = 0.6;
        shadow-offset-x = -7;
        shadow-offset-y = -7;
        shadow-color = "#${base01}";

        # Shadow exclusions
        shadow-exclude = [
          "name = 'Notification'",
          "class_g = 'Conky'",
          "class_g ?= 'Notify-osd'",
          "class_g = 'Cairo-clock'",
          "class_g = 'slop'",
          "class_g = 'Polybar'",
          "_GTK_FRAME_EXTENTS@:c"
        ];

        #################################
        # Fading                        #
        #################################
        fading = true;
        fade-in-step = 0.03;
        fade-out-step = 0.03;
        fade-delta = 10;

        #################################
        # Transparency / Opacity        #
        #################################
        inactive-opacity = 0.95;
        frame-opacity = 0.9;
        inactive-opacity-override = false;
        active-opacity = 1.0;

        # Opacity rules
        opacity-rule = [
          "100:name *= 'Firefox'",
          "100:name *= 'Chromium'",
          "100:class_g = 'kitty' && focused",
          "90:class_g = 'kitty' && !focused",
          "100:class_g = 'Rofi'",
          "90:class_g = 'Thunar'",
          "95:class_g = 'Code'"
        ];

        #################################
        # Background-Blurring           #
        #################################
        blur: {
          method = "dual_kawase";
          strength = 5;
          background = false;
          background-frame = false;
          background-fixed = false;
        }

        # Blur exclusions
        blur-background-exclude = [
          "window_type = 'dock'",
          "window_type = 'desktop'",
          "_GTK_FRAME_EXTENTS@:c",
          "class_g = 'slop'",
          "class_g = 'Firefox' && argb"
        ];

        #################################
        # General Settings              #
        #################################
        backend = "glx";
        vsync = true;
        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        detect-transient = true;
        use-damage = true;
        log-level = "warn";

        # Window type settings
        wintypes:
        {
          tooltip = { fade = true; shadow = true; opacity = 0.95; focus = true; full-shadow = false; };
          dock = { shadow = false; clip-shadow-above = true; }
          dnd = { shadow = false; }
          popup_menu = { opacity = 0.95; }
          dropdown_menu = { opacity = 0.95; }
        };

        #################################
        # Corner Radius                 #
        #################################
        corner-radius = 0;
        rounded-corners-exclude = [
          "window_type = 'dock'",
          "window_type = 'desktop'",
          "class_g = 'Polybar'",
          "class_g = 'Dunst'"
        ];

        #################################
        # Experimental Features         #
        #################################
        experimental-backends = true;

        # GLX backend specific settings
        glx-no-stencil = true;
        glx-copy-from-front = false;

        # Performance optimizations
        unredir-if-possible = true;
        refresh-rate = 60;
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

        format-volume-prefix = " "
        format-volume-prefix-foreground = ''${colors.primary}
        format-volume = <label-volume>

        label-volume = %percentage%%

        label-muted =
        label-muted-foreground = ''${colors.disabled}

        [module/memory]
        type = internal/memory
        interval = 2
        format-prefix = " "
        format-prefix-foreground = ''${colors.primary}
        label = %percentage_used:2%%

        [module/cpu]
        type = internal/cpu
        interval = 2
        format-prefix = " "
        format-prefix-foreground = ''${colors.primary}
        label = %percentage:2%%

        [module/wlan]
        type = internal/network
        interface-type = wireless
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
        tay-maxsize = 20

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
    playerctl # Media player controls
  ];
}
