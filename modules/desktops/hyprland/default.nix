{ pkgs
, hyprland-extra-config
, user
, wallpaper
, lib
, unstable
, config
, inputs
, ...
}: {
  imports = [
    ./waybar
    ./lockscreen

    ../../tools/darkman
    ../../tools/rofi
    ../../tools/thunar
  ];

  environment.systemPackages = with pkgs; [
    unstable.libdrm

    hyprnome
    hyprpicker

    hyprcursor
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default

    unstable.nwg-displays

    # pyprland

    libreoffice-fresh
    pkgs.gnome-disk-utility
    baobab
    polkit-kde-agent
    okular
    vlc
    libnotify
    xarchiver

    # Audio
    easyeffects
    pamixer
    pavucontrol
    helvum
    playerctl

    gamemode

    # Sreenshot
    grimblast

    # Clipboard
    cliphist
    wl-clipboard

    orchis-theme

    # Xfce Tools
    xfce.ristretto
    xfce.thunar
    xfce.xfce4-taskmanager
    xfce.mousepad
    xfce.exo
    libinput-gestures
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    fira-code
    fira-code-symbols
  ];

  programs.hyprland = {
    enable = true;
    package = unstable.hyprland;
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  xdg.portal = {
    enable = true;
    # extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };

  programs.kdeconnect.enable = true;
  services.dbus.enable = true;


  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  ##################
  ## home-manager ##
  ##################
  home-manager = {
    # sharedModules = [
    #   inputs.hyprland.homeManagerModules.default
    # ];

    users.${user} = {

      services = {
        swaync.enable = true;
        swayosd.enable = true;
      };

      xfconf.settings = {
        thunar = {
          "last-show-hidden" = true;
        };
      };

      home = {
        file = {
          ".config/xfce4/helpers.rc".text = ''
            TerminalEmulator=kitty
            FileManager=thunar
            WebBrowser=firefox
          '';
          ".config/hypr/pyprland.toml".text = ''
            [pyprland]
            plugins = [
                "magnify"
            ]
          '';
          # "".text = ''
          # '';
        };
        pointerCursor = {
          # package = pkgs.phinger-cursors;
          # name = "phinger-cursors-light";
          package = pkgs.rose-pine-cursor;
          name = "BreezeX-RosePine-Linux";
          gtk.enable = true;
          x11.enable = true;
        };
      };


      services.mpd-mpris.enable = true;

      services.hyprpaper = {
        enable = true;
        settings = {
          splash = false;
          preload = [
            "${wallpaper}"
          ];
          wallpaper = [
            ",${wallpaper}"
          ];
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        systemd.enable = true;

        plugins = with pkgs.hyprlandPlugins;[
          hyprtrails
          hyprspace
          hypr-dynamic-cursors
          hyprgrass
        ];
        extraConfig = ''
                    ##
                    # System dependend hyperland config
                    ##
                    ${hyprland-extra-config}

                    ###########
                    # Monitor #
                    ###########

                    source = ~/.config/hypr/monitors.conf

                    #############
                    # Autostart #
                    #############
                    exec-once= ${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
                    exec-once= ${config.programs.kdeconnect.package}/libexec/kdeconnectd
                    exec-once = wl-paste --watch cliphist store
                    exec-once = ${pkgs.solaar}/bin/solaar -w hide
                    exec-once = ${pkgs.wlsunset}/bin/wlsunset

                    exec-once = waybar

                    ################
                    # Window Rules #
                    ################
                    windowrulev2=float,title:^(Firefox — Sharing Indicator)$
                    windowrulev2=tile,class:Godot

                    workspace = w[tv1], gapsout:0, gapsin:0
                    workspace = f[1], gapsout:0, gapsin:0
                    windowrulev2 = bordersize 0, floating:0, onworkspace:w[tv1]
                    windowrulev2 = rounding 0, floating:0, onworkspace:w[tv1]
                    windowrulev2 = bordersize 0, floating:0, onworkspace:f[1]
                    windowrulev2 = rounding 0, floating:0, onworkspace:f[1]

                    ########
                    # Envs #
                    ########
                    env = QT_QPA_PLATFORM,wayland;xcb # enables automatic scaling, based on the monitors pixel density
                    env = QT_AUTO_SCREEN_SCALE_FACTOR,1 # Tell QT applications to use the Wayland backend, and fall back to x11 if Wayland is unavailable
                    env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1 # Disables window decorations on QT applications
                    env = GDK_SCALE,1
                    env = NIXOS_OZONE_WL,1
                    env = HYPRCURSOR_THEME,rose-pine-hyprcursor

                    ############
                    # Keybinds #
                    ############
                    $mainMod = SUPER

                    bind = $mainMod, w, killactive,

                    bind = $mainMod ALT, Left, workspace, m-1000
                    bind = $mainMod, Left, exec, ${pkgs.hyprnome}/bin/hyprnome --previous --no-empty
                    bind = $mainMod SHIFT, Left, exec, ${pkgs.hyprnome}/bin/hyprnome --previous --move --no-empty

                    bind = $mainMod , Right, exec, ${pkgs.hyprnome}/bin/hyprnome
                    bind = $mainMod SHIFT, Right, exec, ${pkgs.hyprnome}/bin/hyprnome --move

                    bind = $mainMod SHIFT, f, togglefloating
                    bind = $mainMod, UP, overview:toggle
                    bind = $mainMod, DOWN, overview:toggle

                    # Groups
                    bind = $mainMod, g, togglegroup
                    bind = $mainMod, Tab, changegroupactive, f
                    bind = $mainMod SHIFT, Tab, changegroupactive, b

                    # Fullscreen
                    bind = $mainMod, m, fullscreen


                    # Move/resize windows with mainMod + LMB/RMB and dragging
                    bindm = $mainMod, mouse:272, movewindow
                    bindm = $mainMod, mouse:273, resizewindow


                    bind = $mainMod, l, exec, ${pkgs.procps}/bin/pidof hyprlock || ${config.programs.hyprlock.package}/bin/hyprlock

                    # # Zoom
                    # bind = $mainMod, plus, exec, ${pkgs.pyprland}/bin/pypr zoom ++0.5
                    # bind = $mainMod SHIFT, plus, exec, ${pkgs.pyprland}/bin/pypr zoom

                    # workspace
                    ${builtins.concatStringsSep "\n" (builtins.map (n: ''
                      workspace = ${n},monitor:${
                        if ((lib.strings.charToInt n) >= 5)
                        then "DP-2"
                        else "DP-1"
                      }
                      bind = $mainMod, ${n}, workspace, ${n}
                      bind = $mainMod SHIFT, ${n}, movetoworkspace, ${n}
                    '') ["1" "2" "3" "4" "5" "6" "7" "8"])}

                    # Clipboard
                    bind = $mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy

                      # Screenshot
                      bind = , Print, exec, grimblast --notify copysave area
                      bind = $mainMod SHIFT, S, exec, grimblast --notify copysave area

                    # Launch Apps
                    bindr= $mainMod, SUPER_L, exec, kill $(pgrep rofi) || rofi -show combi
                    bind = $mainMod, Return, exec, kitty
                    bind = $mainMod, e, exec, thunar
                    bind = $mainMod, f, exec, firefox

                      bind = Alt, K, exec, thunar

                    # Mediakeys and osd
                    bind= $mainMod, n, exec, ${config.home-manager.users.${user}.services.swaync.package}/bin/swaync-client -t
                    bindr= $mainMod, Space, exec, kill $(pgrep waybar) || ${config.home-manager.users.${user}.programs.waybar.package}/bin/waybar

                    bindn=, Caps_Lock, exec, sleep 0.25 && ${config.home-manager.users.${user}.services.swayosd.package}/bin/swayosd-client --caps-lock

                    bindel=, XF86AudioRaiseVolume, exec, ${config.home-manager.users.${user}.services.swayosd.package}/bin/swayosd-client --output-volume=+5
                    bindel=, XF86AudioLowerVolume, exec, ${config.home-manager.users.${user}.services.swayosd.package}/bin/swayosd-client --output-volume=-5
                    bindl=, XF86AudioMute, exec, ${config.home-manager.users.${user}.services.swayosd.package}/bin/swayosd-client --output-volume=mute-toggle

                    bindle=, XF86MonBrightnessUp, exec, ${config.home-manager.users.${user}.services.swayosd.package}/bin/swayosd-client --brightness=+5
                    bindle=, XF86MonBrightnessDown, exec, ${config.home-manager.users.${user}.services.swayosd.package}/bin/swayosd-client --brightness=-5

                    bindl=, XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause # the stupid key is called play , but it toggles 
                    bindl=, XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next 
                    bindl=, XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous

                    #########
                    # Decor #
                    #########
                    decoration {
                      active_opacity = 0.98
                      inactive_opacity = 0.90
                      rounding = 8
                      dim_inactive = false
                      dim_strength = 0.3
           #           drop_shadow = false

                      blur {
                        size = 10
                        passes = 3
                      }
                    }

                    animations {
                      animation = windowsIn, 1, 7, default, slide
                      animation = windowsOut, 1, 7, default, slide
                      animation = border, 1, 10, default
                      animation = fade, 1, 7, default
                      animation = workspaces, 1, 5, default
                    }

                    ###########
                    # General #
                    ###########
                    input {
                      kb_layout = us(altgr-intl),de(qwerty)
                      kb_options = grp:switch,caps:escape_shifted_capslock
                      sensitivity = 0
                    }

                    input:touchpad {
                      natural_scroll = true
                      clickfinger_behavior = true
                    }

                    general {
                      gaps_in = 2
                      gaps_out = 5
                      border_size = 0
                      resize_on_border = true
                      layout = dwindle
                    }

                    cursor {
                      inactive_timeout = 3
                      # no_hardware_cursors = true
                    }

                    dwindle {
                      pseudotile = true
                      preserve_split = true # you probably want this
                      smart_split = true
          #            no_gaps_when_only = true
                    }

                    misc {
                      vrr = 1
                      mouse_move_enables_dpms = true
                      disable_hyprland_logo = true
                    }

                    binds {
                      allow_workspace_cycles = true
                    }

                    xwayland {
                      force_zero_scaling = true
                    }


                    plugin {
                      # hyprexpo {
                      #     columns = 3
                      #     gap_size = 8
                      #     bg_col = rgb(111111)
                      #     workspace_method = center current # [center/first] [workspace] e.g. first 1 or center m+1

                      #     enable_gesture = true # laptop touchpad
                      #     gesture_fingers = 3  # 3 or 4
                      #     gesture_distance = 300 # how far is the "max"
                      #     gesture_positive = false # positive = swipe down. Negative = swipe up.
                      # }
                      touch_gestures {
                        sensitivity = 10.0
                      }

                      overview {
                        showEmptyWorkspace = false
                        hideBackgroundLayers = false
                        exitOnSwitch = true
                        affectStrut = false
                      }

                      hyprtrails {
                        color = rgba(f74802ff)
                      }

                      dynamic-cursors {
                        enabled = true
                        mode = stretch

                        shake {
                          effects = true
                        }
                      }
                    }
        '';
      };
    };
  };
}
