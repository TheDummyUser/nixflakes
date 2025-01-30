{ config, pkgs, ... }:

{
  # Bspwm configuration files
  xdg.configFile = {
    "bspwm/bspwmrc" = {
      text = ''
        #!/bin/sh

        bspc rule -r "*"
        killall "nm-applet"
        nm-applet &
        killall "picom"
        picom -b --config ~/.config/picom/picom.conf &
        xrandr --output HDMI-2 --mode 1920x1080 --rate 60 &
        feh --bg-fill /mnt/Localdisk/folder/wall/wallhaven-96wpld.jpg &

        killall "dunst"
        dunst &
        sxhkd &
        killall "polybar"
        polybar main &

        # Bspwm settings
        bspc monitor -d 1 2 3 4 5 6 7 8 9
        bspc config border_width    3
        bspc config window_gaps     5
        bspc config split_ratio     0.5
        bspc config borderless_monocle true
        bspc config gapless_monocle true
        bspc config normal_border_color "${config.colorScheme.palette.base08}"
        bspc config focused_border_color "${config.colorScheme.palette.base09}"
        bspc config urgent_border_color "${config.colorScheme.palette.base0A}"
        bspc config presel_border_color "${config.colorScheme.palette.base0B}"

        xsetroot -cursor_name Bibata-Modern-Ice
      '';
      executable = true;
    };

    "sxhkd/sxhkdrc" = {
      text = ''
        # Terminal
        super + t
              kitty

        super + w
              firefox

        super + shift + r
              bspc wm -r

        super + shift + q
              pkill bspwm

        # Close window

        super + q
          bspc node -c

        super + space
            ~/nixflakes/randomImagePicker/./fehbg

        super + {shift + t, shift + f, shift + v}
              bspc node -t {tiled, fullscreen, floating}

        super + {_,shift + }{h,j,k,l}
              bspc node -{f,s} {west,south,north,east}


        super + {1-9}
              bspc desktop -f '^{1-9}'

        # Rofi launcher
        super + r
          rofi -show drun
      '';
    };

    # Picom configuration file
    "picom/picom.conf" = {
      text = ''
        # Shadows (only for floating windows)
        shadow = true;
        shadow-radius = 12;
        shadow-opacity = 0.75;
        shadow-offset-x = -5;
        shadow-offset-y = -5;
        shadow-exclude = [
          "class_g = 'Polybar'",       # Exclude Polybar
          "class_g = 'Waybar'",        # Exclude Waybar
          "class_g = 'Rofi'",          # Exclude Rofi
          "class_g = 'Dunst'",         # Exclude Dunst notifications
          "class_g = 'Conky'",         # Exclude Conky
          "class_g ?= 'Notify-osd'",   # Exclude Notify-osd
          "name = 'Notification'",     # Exclude notifications
          "_GTK_FRAME_EXTENTS@:c",     # Exclude GTK frame extents
          "window_type = 'dock'",      # Exclude dock windows
          "window_type = 'desktop'"    # Exclude desktop windows
        ];

        # Fading
        fading = true;
        fade-in-step = 0.03;
        fade-out-step = 0.03;
        fade-delta = 5;

        # Blur (disabled for Rofi)
        blur: {
          method = "dual_kawase";
          strength = 5;
          background = true;
          background-frame = true;
          background-fixed = true;
        };

        blur-background-exclude = [
          "class_g = 'Rofi'"
        ];

        # Animations
        animations = true;
        animation-window-mass = 0.5;
        animation-stiffness = 200;
        animation-dampening = 25;
        animation-clamping = true;
        animation-for-open-window = "zoom";
        animation-for-unmap-window = "squeeze";
        animation-for-transient-window = "slide-down";

        # Other settings
        backend = "glx";
        vsync = true;
        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        detect-transient = true;
        glx-no-stencil = true;
        glx-no-rebind-pixmap = true;
        use-damage = true;
        xrender-sync-fence = true;

        # Shadow only for floating windows
        shadow-ignore-shaped = false;
        shadow-ignore-shaping = false;
        shadow-clip-list = [
          "! name *= 'floating'"
        ];
      '';
    };
  };

  # Polybar config (simplified)
  xdg.configFile."polybar/config.ini".text = ''
            [bar/main]
            width = 100%
            height = 28
            radius = 0.0
            fixed-center = true
            background = ${config.colorScheme.palette.base00}
            foreground = ${config.colorScheme.palette.base07}
            modules-left = bspwm
            modules-center = date
            modules-right = volume network tray
            font-0 = "JetBrainsMono Nerd Font:size=9"

            [module/bspwm]
            type = internal/bspwm
            label-focused = %name%
            label-focused-background = ${config.colorScheme.palette.base02}
            label-focused-foreground = ${config.colorScheme.palette.base07}
            label-focused-padding = 2
            label-occupied = %name%
            label-occupied-padding = 2
            label-urgent = %name%!
            label-urgent-background = ${config.colorScheme.palette.base08}
            label-empty = %name%
            label-empty-padding = 2
            label-empty-backfround = ${config.colorScheme.palette.base00}60
            label-empty-foreground = ${config.colorScheme.palette.base07}60

            [module/date]
            type = internal/date
            interval = 1
            date = " %Y-%m-%d  %H:%M"
            label = %date%
            label-font = 2
            label-foreground = ${config.colorScheme.palette.base06}

            [module/volume]
    type = internal/alsa
    format-volume = <ramp-volume> <label-volume>
    format-volume-foreground = ${config.colorScheme.palette.base07}
    label-volume = %percentage%%
    format-muted =  muted
    format-muted-foreground = ${config.colorScheme.palette.base08}
    ramp-volume-0 = 
    ramp-volume-1 = 
    ramp-volume-2 = 

            [module/network]
             type = internal/network
             interface = wlp0s20f0u5  # Use the correct interface name
             interval = 5
             label-connected = %{F${config.colorScheme.palette.base07}}%{F-} %essid%
             label-disconnected = %{F${config.colorScheme.palette.base08}}%{F-} Offline
             ping-interval = 30
             ping-host = 8.8.8.8

            [module/tray]
            type = internal/tray
            spacing = 8
            background = ${config.colorScheme.palette.base00}
            tray-background = ${config.colorScheme.palette.base00}
            tray-foreground = ${config.colorScheme.palette.base00}
            tray-padding = 4
  '';
}
