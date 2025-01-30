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
        picom -b &
        killall "emacs"
        emacs --daemon &
        xrandr --output HDMI-2 --mode 1920x1080 --rate 60 &
        feh --bg-fill /mnt/Localdisk/folder/wall/wallhaven-96wpld.jpg &

        killall "dunst"
        dunst &
        sxhkd &
        polybar main &

        # Bspwm settings
        bspc monitor -d 1 2 3 4 5 6 7 8 9
        bspc config border_width    2
        bspc config window_gaps     5
        bspc config split_ratio     0.5
        bspc config borderless_monocle true
        bspc config gapless_monocle true

        xsetroot -cursor_name Bibata_Modern_Ice
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
    modules-right = pulseaudio network battery tray
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

    [module/pulseaudio]
    type = internal/pulseaudio
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
    interface =  wlp0s20f0u5 # Change to your interface (use 'ip link')
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
