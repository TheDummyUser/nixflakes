{ config, ... }:
{
  xdg.configFile = {
    "qtile/config.py" = {
      text = ''
        from libqtile import bar, layout, qtile, widget, hook
        from libqtile.config import Click, Drag, Group, Key, Match, Screen
        from libqtile.lazy import lazy
        from libqtile.utils import guess_terminal
        import subprocess
        import os

        @hook.subscribe.startup
        def autostart():
            # Set screen resolution (replace HDMI-2 with your monitor's output name if necessary)
            subprocess.Popen(['xrandr', '--output', 'HDMI-2', '--mode', '1920x1080', '--rate', '60'])
            # Set wallpaper
            random_wallpaper = os.path.expanduser("~/nixflakes/randomImagePicker/./fehbg")
            subprocess.Popen([random_wallpaper])

            # Start Picom compositor
            subprocess.Popen(['picom'])
            # Start additional applications
            subprocess.Popen(['vesktop'])
            subprocess.Popen(['nm-applet'])

        mod = "mod4"
        terminal = guess_terminal()
        rofi = "rofi -show drun"
        wall = os.path.expanduser("~/nixflakes/randomImagePicker/./fehbg")
        # Multimedia key bindings using Pipewire commands
        keys = [
            # Window management keys...
            Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
            Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
            Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
            Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
            Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
            Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
            Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
            Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
            Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
            Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
            Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
            Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
            Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
            Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
            Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
            Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
            Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
            Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
            Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window"),
            Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
            Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
            Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
            Key([mod], "r", lazy.spawn(rofi), desc="Launch Rofi"),
        Key([mod, "shift"], "space", lazy.spawn(wall), desc="Wallpaper switch"),
            # Multimedia keys for volume, brightness, and media control
            Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), desc="Increase volume"),
            Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), desc="Decrease volume"),
            Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), desc="Mute volume"),
            Key([], "XF86AudioMicMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), desc="Toggle microphone mute"),
            Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl s 10%+"), desc="Increase brightness"),
            Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl s 10%-"), desc="Decrease brightness"),
            Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc="Next track"),
            Key([], "XF86AudioPause", lazy.spawn("playerctl play-pause"), desc="Play/Pause track"),
            Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc="Play/Pause track"),
            Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc="Previous track"),
        ]

        # Add key bindings to switch VTs in Wayland.
        for vt in range(1, 8):
            keys.append(
                Key(
                    ["control", "mod1"],
                    f"f{vt}",
                    lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
                    desc=f"Switch to VT{vt}",
                )
            )

        groups = [Group(i) for i in "123456789"]

        for i in groups:
            keys.extend(
                [
                    Key([mod], i.name, lazy.group[i.name].toscreen(), desc=f"Switch to group {i.name}"),
                    Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc=f"Switch to & move focused window to group {i.name}"),
                ]
            )

        layout_theme = {
            "border_width": 2,
            "margin": 5,
            "border_focus": "FFFFFF",
            "border_normal": "CCCCCC"
        }

        layouts = [
            layout.MonadTall(**layout_theme),
        ]

        widget_defaults = dict(
            font="JetBrainsMono Nerd Font",
            fontsize=12,
            padding=3,
            foreground="#D8DEE9",
        )
        extension_defaults = widget_defaults.copy()

        screens = [
            Screen(
                top=bar.Bar(
                    [
                        widget.GroupBox(
                            font="JetBrainsMono Nerd Font",
                            fontsize=14,
                            active="#D8DEE9",
                            inactive="#81A1C1",
                            this_current_screen_border="#88C0D0",
                            this_screen_border="#88C0D0",
                            other_current_screen_border="#4C566A",
                            other_screen_border="#4C566A",
                            rounded=False,
                            highlight_method="line",
                        ),
                        widget.Prompt(),
                        widget.Chord(
                            chords_colors={
                                "launch": ("#ff0000", "#ffffff"),
                            },
                            name_transform=lambda name: name.upper(),
                        ),
                        widget.Spacer(length=bar.STRETCH),
                        widget.Clock(format="%Y-%m-%d %a %I:%M %p", foreground="#88C0D0"),
                        widget.Spacer(length=bar.STRETCH),
                        # Updated Volume widget for Pipewire
                        widget.Volume(
                            fmt="Vol: {}",
                            step=5,
                            update_interval=0.5,
                            get_volume_cmd=["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"],
                            set_volume_cmd=["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "{volume}%"],
                            mute_command=["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"],
                            parse_volume=lambda output: int(float(output.split()[1]) * 100)
                            if len(output.split()) > 1 else 0,
                        ),
                        widget.Systray(icon_size=14),
                        widget.QuickExit(),
                    ],
                    32,  # Bar height
                    margin=[5, 5, 5, 5],  # Margins: top, right, bottom, left
                    background=["#2E3440", "#3B4252"],
                    border_width=[0, 0, 0, 0],
                    border_color=["#ff00ff", "#000000", "#ff00ff", "#000000"],
                ),
            ),
        ]

        mouse = [
            Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
            Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
            Click([mod], "Button2", lazy.window.bring_to_front()),
        ]

        dgroups_key_binder = None
        dgroups_app_rules = []  # type: list
        follow_mouse_focus = True
        bring_front_click = False
        floats_kept_above = True
        cursor_warp = False
        floating_layout = layout.Floating(
            float_rules=[
                *layout.Floating.default_float_rules,
                Match(wm_class="confirmreset"),  # gitk
                Match(wm_class="makebranch"),  # gitk
                Match(wm_class="maketag"),  # gitk
                Match(wm_class="ssh-askpass"),  # ssh-askpass
                Match(title="branchdialog"),  # gitk
                Match(title="pinentry"),  # GPG key password entry
            ]
        )
        auto_fullscreen = True
        focus_on_window_activation = "smart"
        reconfigure_screens = True
        auto_minimize = True
        wl_input_rules = None
        wl_xcursor_theme = None
        wl_xcursor_size = 24
        wmname = "LG3D"

      '';
    };
  };
}
