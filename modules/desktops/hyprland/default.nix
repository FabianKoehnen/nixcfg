{ home-manager, inputs, pkgs, hyprpkgs, user, wallpaper, lib, ... }:
{
  imports = [
    ../../tools/rofi
    ../../tools/thunar
  ];

  environment.systemPackages = with pkgs; [
    # Audio
    easyeffects

    # Sreenshot
    hyprpkgs.grimblast

    # Clipboard
    cliphist
    wl-clipboard

    # Wallpaper
    hyprpaper

    # Xfce Tools
    xfce.ristretto
    xfce.xfce4-taskmanager
    xfce.mousepad
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  security.rtkit.enable = true;
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


  ##################
  ## home-manager ##
  ##################
  home-manager = {
    sharedModules = [
      inputs.hyprland.homeManagerModules.default
    ];

    users.${user} = {
      programs = {
        eww = {
          enable = true;
          package = pkgs.eww-wayland;
          configDir = ./eww;
        };
      };

      services = {
        dunst = {
          enable = true;
        };
      };

      home.file = {
        ".config/hypr/hyprpaper.conf".text = ''
          preload = ${wallpaper}

          wallpaper = , ${wallpaper}
        '';
      };


      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = ''
          ###########
          # Monitor #
          ###########
          monitor = HDMI-A-1, 1920x1080, 0x0, 1
          monitor = DP-2, 1920x1080, 1920x0, 1

          #############
          # Autostart #
          #############
          exec-once = wl-paste --watch cliphist store
          exec-once = hyprpaper

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

          ############
          # Keybinds #
          ############
          $mainMod = SUPER

          bind = $mainMod, w, killactive,

          bind = $mainMod, h, workspace, e-1
          bind = $mainMod, l, workspace, +1

          bind = $mainMod, Tab, cyclenext,
          bind = $mainMod SHIFT, Tab, cyclenext, prev
          
          bind = $mainMod CTRL, Tab, focusmonitor, +1

          bind = $mainMod SHIFT, f, togglefloating

          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow

          # Worklogs
          bind = $mainMod, 1, moveworkspacetomonitor, 1 current
          bind = $mainMod, 1, workspace, 1
          bind = $mainMod, 2, moveworkspacetomonitor, 2 current
          bind = $mainMod, 2, workspace, 2
          bind = $mainMod, 3, moveworkspacetomonitor, 3 current
          bind = $mainMod, 3, workspace, 3
          bind = $mainMod, 4, moveworkspacetomonitor, 4 current
          bind = $mainMod, 4, workspace, 4
          bind = $mainMod, 5, moveworkspacetomonitor, 5 current
          bind = $mainMod, 5, workspace, 5
          bind = $mainMod, 6, moveworkspacetomonitor, 6 current
          bind = $mainMod, 6, workspace, 6

          bind = $mainMod SHIFT, 1, movetoworkspace, 1
          bind = $mainMod SHIFT, 2, movetoworkspace, 2
          bind = $mainMod SHIFT, 3, movetoworkspace, 3
          bind = $mainMod SHIFT, 4, movetoworkspace, 4
          bind = $mainMod SHIFT, 5, movetoworkspace, 5
          bind = $mainMod SHIFT, 6, movetoworkspace, 6

          # Clipboard
          bind = $mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy

          # Screenshot
          bind = , Print, exec, grimblast --notify copysave area

          # Launch Apps
          bindr= $mainMod, SUPER_L, exec, pkill rofi || rofi -show combi
          bind = $mainMod, Return, exec, wezterm
          bind = $mainMod, e, exec, thunar

          #########
          # Decor #
          #########
          decoration {
            active_opacity = 0.90
            inactive_opacity = 0.82
            rounding = 8
            dim_inactive = false
            dim_strength = 0.3
            drop_shadow = false

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

          general {
            gaps_in = 2
            gaps_out = 5
            border_size = 0
            cursor_inactive_timeout = 30
            resize_on_border = true
            layout = dwindle
          }

          dwindle {
            pseudotile = true
            preserve_split = true # you probably want this
            smart_split = true
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
        '';
      };
    };
  };
}