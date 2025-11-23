{ config, pkgs, nix-colors, ... }:
let
  palette = config.colorScheme.palette;

  hexToRgba = 
    hex: alpha:
    let
    in
     "rgba(${hex}${alpha})";

  convert = nix-colors.lib.conversions.hexToRGBString;
in
{

  home.file = {
    "Pictures/Wallpapers/background" = {
      source = ../resources/background.jpg;
      recursive = true;
    };
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "${config.home.homeDirectory}/Pictures/Wallpapers/background"
      ];
      wallpaper = [
        ",${config.home.homeDirectory}/Pictures/Wallpapers/background"
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        no_fade_in = false;
      };
      auth = {
        fingerprint.enabled = true;
      };
      background = {
        monitor = "";
       # path = selected_wallpaper_path;
        # blur_passes = 3;
        # brightness = 0.5;
      };

      input-field = {
        monitor = "";
        size = "600, 100";
        position = "0, 0";
        halign = "center";
        valign = "center";

        inner_color = "rgb(${convert ", " palette.base02})";
        outer_color = "rgb(${convert ", " palette.base05})";
        outline_thickness = 4;

        font_family = "CaskaydiaMono Nerd Font";
        font_size = 32;
        font_color = "rgb(${convert ", " palette.base05})";

        placeholder_color = "rgb(${convert ", " palette.base04})";
        placeholder_text = "  Enter Password 󰈷 ";
        check_color = "rgba(131, 192, 146, 1.0)";
        fail_text = "Wrong";

        rounding = 0;
        shadow_passes = 0;
        fade_on_empty = false;
      };

      label = {
        monitor = "";
        text = "\$FPRINTPROMPT";
        text_align = "center";
        color = "rgb(211, 198, 170)";
        font_size = 24;
        font_family = "CaskaydiaMono Nerd Font";
        position = "0, -100";
        halign = "center";
        valign = "center";
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
        }
      ];
    };
  };

  services.hyprpolkitagent.enable = true;
 
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Variables
      "$terminal" = "ghostty";
      "$fileManager" = "nautilus --new-window";
      "$browser" = "zen";
      "$notes" = "obsidian -disable-gpu";

      # Monitors
      monitor = [ # THis would be good to calcualte somehow
        "eDP-1, 1920x1080@60, auto, auto"
      ];

      # Autostart
      exec-once = [
        "hyprsunset"
        "hyprpaper"
        "systemctl --user start hyprpolkitagent"
        "wl-clip-persist --clipboard regular & clipse -listen"
      ];
      exec = [
         "pkill -SIGUSR2 waybar || waybar"
      ];

      # Bindings
      bind = [
        "SUPER, F1, exec, ~/.local/share/show-keybindings"
        "SUPER, RETURN, exec, $terminal"
        "SUPER, F, exec, $fileManager"
        "SUPER, N, exec, $terminal -e nvim"
        "SUPER, B, exec, $browser"
        "SUPER, K, exec, $notes"
        "SUPER, slash, exec, $passwordManager"

        "SUPER, SPACE, exec, wofi --show drun --sort-order=alphabetical"
        "SUPER SHIFT, SPACE, exec, pkill -SIGUSR1 waybar"
        "SUPER, Backspace, killactive,"
        # End Session
        "SUPER, ESCAPE, exec, hyprlock"
        "SUPER SHIFT, ESCAPE, exit,"
        "SUPER CTRL, ESCAPE, exec, reboot,"
        "SUPER SHIFT CTRL, ESCAPE, exec, systemctl poweroff"
        # Control Tiling
        "SUPER, J, togglesplit,"
        "SUPER, P, pseudo,"
        "SUPER, V, togglefloating"
        "SUPER SHIFT, PlUS, fullscreen,"
        # Focus
        "SUPER, LEFT, movefocus, l"
        "SUPER, RIGHT, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
        # Workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        "SUPER, COMMA, workspace, -1"
        "SUPER, PERIOD, workspace, +1"

        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

         # Super workspace floating layer
        "SUPER, S, togglespecialworkspace, magic"
        "SUPER SHIFT, S, movetoworkspace, special:magic"

        # Windows
        # Swap active window with the one next to it with mainMod + SHIFT + arrow keys
        "SUPER SHIFT, left, swapwindow, l"
        "SUPER SHIFT, right, swapwindow, r"
        "SUPER SHIFT, up, swapwindow, u"
        "SUPER SHIFT, down, swapwindow, d"

        # Resize active window
        "SUPER, minus, resizeactive, -100 0"
        "SUPER, equal, resizeactive, 100 0"
        "SUPER SHIFT, minus, resizeactive, 0 -100"
        "SUPER SHIFT, equal, resizeactive, 0 100"

        # Scroll through existing workspaces with mainMod + scroll
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"
     
        # Screenshots
        ", PRINT, exec, hyprshot -m region"
        "SHIFT, PRINT, exec, hyprshot -m window"
        "CTRL, PRINT, exec, hyprshot -m output"

        # Color picker
        "SUPER, PRINT, exec, hyprpicker -a"

        # Clipse
        "CTRL SUPER, V, exec, ghostty --class clipse -e clipse"
      ];
      
      bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];

    bindel = [
      # Laptop multimedia keys for volume and LCD brightness
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
    ];

    bindl = [
      # Requires playerctl
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

    # Environment
    env = [
     "GDK_SCALE,1"     
     # Cursor size
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"

      # Cursor theme
      "XCURSOR_THEME,Adwaita"
      "HYPRCURSOR_THEME,Adwaita"

      # Force all apps to use Wayland
      "GDK_BACKEND,wayland"
      "QT_QPA_PLATFORM,wayland"
      "QT_STYLE_OVERRIDE,kvantum"
      "SDL_VIDEODRIVER,wayland"
      "MOZ_ENABLE_WAYLAND,1"
      "ELECTRON_OZONE_PLATFORM_HINT,wayland"
      "OZONE_PLATFORM,wayland"

      # Make Chromium use XCompose and all Wayland
      "CHROMIUM_FLAGS,\"--enable-features=UseOzonePlatform --ozone-platform=wayland --gtk-version=4\""

      # Make .desktop files available for wofi
      "XDG_DATA_DIRS,$XDG_DATA_DIRS:$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share"

      # Use XCompose file
      "XCOMPOSEFILE,~/.XCompose"
      "EDITOR,nvim"

      # GTK theme
      # "GTK_THEME,${if cfg.theme == "generated_light" then "Adwaita" else "Adwaita:dark"}"

      ];


      xwayland = {
        force_zero_scaling = true;
      };

      # Don't show update on first launch
      ecosystem = {
        no_update_news = true;
      };

      input = {
        kb_layout = "us";
        kb_options = "compose:caps";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
      };


      # Window Rules
      windowrule = [
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      "suppressevent maximize, class:.*"

      # Force chromium into a tile to deal with --app bug
      "tile, class:^(chromium)$"

      # Settings management
      "float, class:^(org.pulseaudio.pavucontrol|blueberry.py)$"

      # Float Steam, fullscreen RetroArch
      "float, class:^(steam)$"
      "fullscreen, class:^(com.libretro.RetroArch)$"

      # Just dash of transparency
      "opacity 0.97 0.9, class:.*"
      # Normal chrome Youtube tabs
      "opacity 1 1, class:^(chromium|google-chrome|google-chrome-unstable)$, title:.*Youtube.*"
      "opacity 1 0.97, class:^(chromium|google-chrome|google-chrome-unstable)$"
      "opacity 0.97 0.9, initialClass:^(chrome-.*-Default)$ # web apps"
      "opacity 1 1, initialClass:^(chrome-youtube.*-Default)$ # Youtube"
      "opacity 1 1, class:^(zoom|vlc|org.kde.kdenlive|com.obsproject.Studio)$"
      "opacity 1 1, class:^(com.libretro.RetroArch|steam)$"

      # Fix some dragging issues with XWayland
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

      # Float in the middle for clipse clipboard manager
      "float, class:(clipse)"
      "size 622 652, class:(clipse)"
      "stayfocused, class:(clipse)"
    ];

    layerrule = [
      # Proper background blur for wofi
      "blur,wofi"
      "blur,waybar"
    ];

    # LooknFeel
    general = {
      gaps_in = 5;
      gaps_out = 10;

      border_size = 2;
     
      "col.active_border" = (hexToRgba config.colorScheme.palette.base09 "aa");
      "col.inactive_border" = (hexToRgba config.colorScheme.palette.base0D "aa"); 

      resize_on_border = false;

      allow_tearing = false;

      layout = "dwindle";
    };


    decoration = {
      rounding = 4;

      shadow = {
        enabled = false;
        range = 30;
        render_power = 3;
        ignore_window = true;
        color = "rgba(00000045)";
      };

      blur = {
        enabled = true;
        size = 5;
        passes = 2;

        vibrancy = 0.1696;
      };
    };

    animations = {
      enabled = true; # yes, please :)

      bezier = [
        "easeOutQuint,0.23,1,0.32,1"
        "easeInOutCubic,0.65,0.05,0.36,1"
        "linear,0,0,1,1"
        "almostLinear,0.5,0.5,0.75,1.0"
        "quick,0.15,0,0.1,1"
      ];

      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 0, 0, ease"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
      force_split = 2;
    };

    master = {
      new_status = "master";
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    };
    };
  };
 



}
