{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.hyprland;
    # systemdIntegration = true;
    settings = {
      # Monitors
      monitor = "HDMI-A-2,1920x1080@60,0x0,1";

      # My Programs
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "rofi -show drun";

      # Autostart
      exec-once = [
        "nm-applet"
        "swww init"
        "swww-daemon"
        "${config.home.homeDirectory}/nixflakes/randomImagePicker/main"
        "pypr"
        "waybar & dunst"
        "[workspace 4 silent] vesktop discord"
        # "bash ~/nixflakes/scripts/swayidle-start.sh"
        "wl-paste -t text --watch clipman store --no-persist"
        "wl-paste -p -t text --watch clipman store -P --histpath=${config.home.homeDirectory}/.local/share/clipman-primary.json"
      ];

      # Environment Variables
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      # Look and Feel
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" =
          "rgb(${config.colorScheme.palette.base0E}) rgb(${config.colorScheme.palette.base0E}) 45deg";
        "col.inactive_border" = "rgb(${config.colorScheme.palette.base02})";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        # active_opacity = 1.0;
        # inactive_opacity = 1.0;
        # drop_shadow = true;
        # shadow_range = 5;
        # shadow_render_power = 6;
        # "col.shadow" = "rgb(${config.colorScheme.palette.base0B})";
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          vibrancy = 0.1696;
        };
      };
      
      animations = {
        enabled = true;
        bezier = [
          "linear,0,0,1,1"
          "md3_standard,0.2,0,0,1"
          "md3_decel,0.05,0.7,0.1,1"
          "md3_accel,0.3,0,0.8,0.15"
          "overshot,0.05,0.9,0.1,1.1"
          "crazyshot,0.1,1.5,0.76,0.92"
          "hyprnostretch,0.05,0.9,0.1,1.0"
          "fluent_decel,0.1,1,0,1"
          "easeInOutCirc,0.85,0,0.15,1"
          "easeOutCirc,0,0.55,0.45,1"
          "easeOutExpo,0.16,1,0.3,1"
        ];
        animation = [
          "windows,1,3,md3_decel,popin 60%"
          "border,1,10,default"
          "fade,1,2.5,md3_decel"
          "workspaces,1,3.5,easeOutExpo,slide"
          "specialWorkspace,1,3,md3_decel,slidevert"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };

      # Input
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      # gestures = {
      #   workspace_swipe = false;
      # };

      device = [
        {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        }
      ];

      # Keybindings
      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, K, exec, clipman pick -t rofi"
        "$mainMod CONTROL , V, exec, clipman clear -t rofi"
        "$mainMod ALT, V, exec, clipman clear --all"
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, PRINT, exec, hyprshot -m window"
        ", PRINT, exec, hyprshot -m output"
        "$mainMod SHIFT, PRINT, exec, hyprshot -m region --clipboard-only"
        "$mainMod, SPACE, exec, ${config.home.homeDirectory}/nixflakes/randomImagePicker/main"
        "$mainMod, L, exec, hyprlock"
        # "$mainMod SHIFT, V,exec, pypr toggle term"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      binde = [
        # Laptop multimedia keys for volume and LCD brightness
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        # Requires playerctl
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Window Rules
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };
}
