{ home-manager
, inputs
, pkgs
, hyprpkgs
, hyprland-extra-config
, user
, wallpaper
, lib
, unstable
, config
, ...
}: {
  imports = [
    ../../tools/darkman
    ../../tools/rofi
    ../../tools/thunar
  ];

  environment.systemPackages = with pkgs; [
    unstable.libdrm

    hyprnome
    hyprpicker
    hyprcursor

    nwg-displays

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

  ##################
  ## home-manager ##
  ##################
  home-manager = {
    # sharedModules = [
    #   inputs.hyprland.homeManagerModules.default
    # ];

    users.${user} = {
      programs = {
        # eww = {
        #   enable = true;
        #   configDir = ./eww;
        # };

        waybar = {
          enable = true;
          settings = {
            mainBar = {
              layer = "top";
              position = "top";
              height = 24;
              spacing = 10;
              modules-left = [ "idle_inhibitor" "hyprland/workspaces" "hyprland/submap" ];
              modules-center = [ "hyprland/window" ];
              modules-right = [ "tray" "gamemode" "wireplumber" "bluetooth" "network" "battery" "custom/notification" "clock" ];
              idle_inhibitor = {
                format = "{icon}";
                format-icons = {
                  activated = "";
                  deactivated = "";
                };
              };
              tray = {
                spacing = 10;
              };
              battery = {
                format = "{capacity}% {icon}";
                format-icons = [ "" "" "" "" "" ];
              };
              clock = {
                format-alt = "{:%a, %d. %b  %H:%M}";
              };
              "hyprland/workspaces" = {
                format = "{icon}";
              };
              "hyprland/window" = {
                separate-outputs = true;
              };
              "custom/notification" = {
                tooltip = false;
                format = "{icon}";
                "format-icons" = {
                  notification = "<span foreground='red'><sup></sup></span>";
                  none = "";
                  "dnd-notification" = "<span foreground='red'><sup></sup></span>";
                  "dnd-none" = "";
                  "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
                  "inhibited-none" = "";
                  "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
                  "dnd-inhibited-none" = "";
                };
                "return-type" = "json";
                "exec-if" = "which swaync-client";
                exec = "swaync-client -swb";
                "on-click" = "swaync-client -t -sw";
                "on-click-right" = "swaync-client -d -sw";
                escape = true;
              };
            };
          };
        };
      };

      services = {
        swaync = {
          enable = true;
        };
        swayosd = {
          enable = true;
        };
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

      programs.hyprlock = {
        enable = true;
        settings = {
          background = [
            {
              monitor = "";
              path = "${wallpaper}";

              blur_passes = 2; # 0 disables blurring
              blur_size = 7;
              noise = 0.0117;
              contrast = 0.8916;
              brightness = 0.8172;
              vibrancy = 0.1696;
              vibrancy_darkness = 0.0;
            }
          ];
          input-field = [
            {
              monitor = "";
              size = "200, 50";
              outline_thickness = 3;
              dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
              dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
              dots_center = true;
              dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
              outer_color = "rgb(151515)";
              inner_color = "rgb(FFFFFF)";
              font_color = "rgb(10, 10, 10)";
              fade_on_empty = true;
              fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
              placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
              hide_input = false;
              rounding = -1; # -1 means complete rounding (circle/oval)
              check_color = "rgb(204, 136, 34)";
              fail_color = "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
              fail_transition = 300; # transition time in ms between normal outer_color and fail_color
              capslock_color = -1;
              numlock_color = -1;
              bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
              invert_numlock = false; # change color if numlock is off
              swap_font_color = false; # see below
              position = "0, -20";
              halign = "center";
              valign = "center";
            }
          ];

          label = [
            {
              monitor = "";
              text = "cmd[update:1000] echo \"$TIME\"";
              color = "rgba(200, 200, 200, 1.0)";
              font_size = 55;
              font_family = "Fira Semibold";
              position = "-100, 60";
              halign = "right";
              valign = "bottom";
              shadow_passes = 5;
              shadow_size = 10;
            }
            {
              monitor = "";
              text = "$USER";
              color = "rgba(200, 200, 200, 1.0)";
              font_size = 20;
              font_family = "Fira Semibold";
              position = "-100, 160";
              halign = "right";
              valign = "bottom";
              shadow_passes = 5;
              shadow_size = 10;
            }
          ];
        };
      };

      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "${pkgs.procps}/bin/pidof hyprlock || ${config.programs.hyprlock.package}/bin/hyprlock"; # avoid starting multiple hyprlock instances.
            before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
            after_sleep_cmd = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
          };
          listener = [
            {
              timeout = 150; # 2.5min.
              on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10 | true"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
              on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r | true"; # monitor backlight restore.
            }
            {
              timeout = 150; # 2.5min.
              on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd rgb:kbd_backlight set 0 | true"; # turn off keyboard backlight.
              on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd rgb:kbd_backlight | true"; # turn on keyboard backlight.
            }
            {
              timeout = 900; # 5min
              on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
            }
            {
              timeout = 930; # 5.5min
              on-timeout = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms off"; # screen off when timeout has passed
              on-resume = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
            }
            {
              timeout = 2700; # 30min
              on-timeout = "systemctl suspend"; # suspend pc
            }
          ];
        };

      };

      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        plugins = [
          pkgs.hyprlandPlugins.hyprtrails
          pkgs.hyprlandPlugins.hyprspace
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
                    exec-once = ${pkgs.wlsunset}/bin/wlsunset -t 3500

                    exec-once = waybar

                    ################
                    # Window Rules #
                    ################
                    windowrulev2=float,title:^(Firefox — Sharing Indicator)$

                    ########
                    # Envs #
                    ########
                    env = QT_QPA_PLATFORM,wayland;xcb # enables automatic scaling, based on the monitors pixel density
                    env = QT_AUTO_SCREEN_SCALE_FACTOR,1 # Tell QT applications to use the Wayland backend, and fall back to x11 if Wayland is unavailable
                    env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1 # Disables window decorations on QT applications
                    env = GDK_SCALE,1
                    env = NIXOS_OZONE_WL,1

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
                      kb_layout = de
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
                    }

                    dwindle {
                      pseudotile = true
                      preserve_split = true # you probably want this
                      smart_split = true
          #            no_gaps_when_only = true
                    }

                    misc {
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

                        overview {
                          showEmptyWorkspace = false
                          hideBackgroundLayers = true
                          exitOnSwitch = true
                          affectStrut = false
                        }

                        hyprtrails {
                          color = rgba(f74802ff)
                        }
                    }
        '';
      };
    };
  };
}
