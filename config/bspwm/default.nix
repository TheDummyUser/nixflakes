{ config, pkgs, ... }:

{
  # Bspwm configuration files
  xdg.configFile = {
    "bspwm/bspwmrc" = {
      text = ''
        #!/usr/bin/env zsh

        # Reset BSPWM rules
        bspc rule -r "*"

        # Kill existing processes
        kill-all "nm-applet"
        kill-all "picom"
        kill-all "dunst"
        kill-all "sxhkd"

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
        feh --bg-fill /mnt/Localdisk/folder/wall/wallhaven-m3j7q9_3840x2160.png

        # Launch Polybar
        ~/.config/polybar/launch.sh

        # Set up BSPWM workspaces
        bspc monitor HDMI-2 -d 1 2 3 4 5 6 7 8 9


        bspc rule -a Emacs state=tiled

        # BSPWM configuration
        bspc config automatic_scheme alternate
        bspc config initial_polarity second_child


        # Focus and window behavior
        bspc config pointer_follows_monitor true
        bspc config focus_follow_pointer true
        bspc config history_aware_focus true

        # Window appearance
        bspc config border_width 3
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
        # Open applications
        super + w
            firefox
        super + t
            kitty
        super + r
            rofi -show drun

        # Restart bspwm
        super + shift + r
            bspc wm -r

        super + space
            ~/nixflakes/randomImagePicker/./fehbg

        # Kill bspwm (use with caution)
        super + shift + q
            pkill bspwm

        # Close window (FIXED TYPO)
        super + q
            bspc node -c

        # Rotate window clockwise
        super + j
            bspc node -R 90

        # Rotate window counter-clockwise (FIXED TYPO)
        super + shift + i
            bspc node -R -90

        # Window states
        super + {shift + t, shift + f, shift + v}
            bspc node -t {tiled,fullscreen,floating}

        # Window movement/focus
        super + {_,shift + }{h,j,k,l}
            bspc node -{f,s} {west,south,north,east}

        # Desktop switching (FIXED DESKTOP SELECTORS)
        super + {_,shift + }{1-9}
            bspc {desktop --focus,node --to-desktop} ^{1-9}

      '';
    };

    "polybar/colors.ini" = {
      text = with config.colorScheme.palette; ''
        [colors]
        base00= #${base00}
        base01= #${base01}
        base02= #${base02}
        base03= #${base03}
        base04= #${base04}
        base05= #${base05}
        base06= #${base06}
        base07= #${base07}
        base08= #${base08}
        base09= #${base09}
        base0A= #${base0A}
        base0B= #${base0B}
        base0C= #${base0C}
        base0D= #${base0D}
        base0E= #${base0E}
        base0F= #${base0F}
      '';
    };
  };
}
